//
//  MainController.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import UIKit
import PanModal
import Combine

final class MovieHomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
   // let viewModel = MovieHomeViewModel()
    var nowShowingMovie: Movie? = nil
    var movie: Movie? = nil
    var headerTitle = "Top Rated"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MovieApp"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(UINib(nibName: K.horizontalCellXib, bundle: nil), forCellWithReuseIdentifier: K.horizontalCellIdentifier)
        collectionView.register(UINib(nibName: K.verticalCellXib, bundle: nil), forCellWithReuseIdentifier: K.verticalCellIdentifier)
        collectionView.register(UINib(nibName: K.headerXib, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.headerIdentifier)
        NetworkManager.shared.requestData(dataType: .topRated, page: 1) { (result) in
            switch result{
            case .success(let movie):
                self.movie = movie
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
                return
            }
        }
        NetworkManager.shared.requestData(dataType: .nowPlaying, page: 1) { (result) in
            switch result{
            case .success(let movie):
                self.nowShowingMovie = movie
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
                return
            }
        }

    }

    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.delegate = self
        presentPanModal(vc)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.homeToDetailSegue{
            let vc = segue.destination as! DetailController
            vc.movie = sender as? Result
        }
    }
    func createLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            if sectionNumber == 0{
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(320)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.createHeader()]
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 16
                return section
            }
            else{
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.createHeader()]
                section.contentInsets.leading = 16
                section.interGroupSpacing = 16
                return section
            }
        }
        return layout

    }
    func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        return header
    }
}
extension MovieHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return nowShowingMovie?.results.count ?? 0
        }
        else{
            return movie?.results.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.verticalCellIdentifier, for: indexPath) as! VerticalCell
            cell.setup(data: nowShowingMovie?.results[indexPath.row] ?? nil)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.horizontalCellIdentifier, for: indexPath) as! HorizontalCell
            cell.setup(data: movie?.results[indexPath.row] ?? nil)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.headerIdentifier, for: indexPath) as! ReusableHeader
            view.setup(title: "Now Showing")
            return view
        }
        else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.headerIdentifier, for: indexPath) as! ReusableHeader
            view.setup(title: headerTitle)
            return view
        }
    }
    //MARK: - Select Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var data: Result?
        if indexPath.section == 0{
            data = nowShowingMovie?.results[indexPath.row]
        }
        else{
            data = movie?.results[indexPath.row]
        }
        performSegue(withIdentifier: K.homeToDetailSegue, sender: data)
    }
}
extension MovieHomeViewController: FilterViewDelegate{
    func didSelectCategory(categoryTitle: String ,category: DataType) {
        self.headerTitle = categoryTitle
        NetworkManager.shared.requestData(dataType: category, page: 1) { (result) in
            switch result{
            case .success(let movie):
                self.movie = movie
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}

