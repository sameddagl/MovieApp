//
//  DetailController.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import UIKit
import SDWebImage
import PanModal
import CoreData

class DetailController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    var movie: Result?
    var cast = [Cast]()
    override func viewDidLoad() {
        super.viewDidLoad()
        genreCollectionView.dataSource = self
        castCollectionView.dataSource = self
        genreCollectionView.register(UINib(nibName: K.genreCellXib, bundle: nil), forCellWithReuseIdentifier: K.genreCellIdentifier)
        castCollectionView.register(UINib(nibName: K.castCellXib, bundle: nil), forCellWithReuseIdentifier: K.castCellIdentifier)
        genreCollectionView.collectionViewLayout = createLayout(for: 0)
        castCollectionView.collectionViewLayout = createLayout(for: 1)
        if let movie = movie{
            movieImageView.sd_setImage(with: URL(string: "\(NetworkHelper.shared.imagePath)/\(movie.backdropPath)"))
            titleLabel.text = movie.title
            ratingLabel.text = "\(movie.voteAverage)/10 IMDb"
            releaseDateLabel.text = movie.releaseDate
            languageLabel.text = Locale(identifier: "en-US").localizedString(forLanguageCode: movie.originalLanguage)
            descriptionLabel.text = movie.overview
            NetworkManager.shared.requestCast(movieID: movie.id) { result in
                switch result{
                case .success(let credits):
                    self.cast = credits.cast
                    self.castCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        save(title: movie!.title, rate: movie!.voteAverage, imagePath: movie!.posterImage, id: movie!.id)
        sender.isSelected.toggle()
    }
    func save(title: String, rate: Double, imagePath: String, id: Int) {
    }
    func createLayout(for num: Int) -> UICollectionViewLayout{
        if num == 0{
            let layout = UICollectionViewCompositionalLayout { sectionNum, env in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(20)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(20)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                return section
            }
            return layout
        }
        else{
            let layout = UICollectionViewCompositionalLayout { sectionNum, env in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .estimated(self.castCollectionView.frame.size.height)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                return section
            }
            return layout
        }
        
    }
    
}
extension DetailController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == genreCollectionView{
            return 1
        }
        else{
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView{
            return movie?.genres.count ?? 0
        }
        else{
            return cast.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView{
            let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: K.genreCellIdentifier, for: indexPath) as! GenreCell
            cell.setup(title: movie?.genres[indexPath.row] ?? "")
            return cell
        }
        else{
            let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: K.castCellIdentifier, for: indexPath) as! CastCell
            cell.setup(data: cast[indexPath.row])
            return cell
        }
    }
}
