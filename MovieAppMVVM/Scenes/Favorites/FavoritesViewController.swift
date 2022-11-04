//
//  FavoritesViewController.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 3.11.2022.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var savedMovies = [FavoriteMovie]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: K.favoriteMovieCellXib, bundle: nil), forCellWithReuseIdentifier: K.favoriteMovieCellIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteMovies()
        print(savedMovies.count)

    }
    
    func loadFavoriteMovies(){
        print("load called")
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do{
            savedMovies = try context.fetch(request)
            collectionView.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
            item.contentInsets.leading = 10
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(320)), subitems: [item])
            group.contentInsets.trailing = 10
            let section = NSCollectionLayoutSection(group: group)
            //section.interGroupSpacing = 16
            return section
        }
        return layout
    }
}
extension FavoritesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(savedMovies.count)
        return savedMovies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.favoriteMovieCellIdentifier, for: indexPath) as! FavoriteMovieCell
        let data = savedMovies[indexPath.row]
        cell.setup(title: data.title!, imageURL: data.posterPath!, rate: data.rate)
        return cell
    }
}
extension FavoritesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = savedMovies[indexPath.row]
        performSegue(withIdentifier: K.favoritesToDetailSegue, sender: data)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.favoritesToDetailSegue{
            let vc = segue.destination as! DetailController
            vc.favMovie = sender.self as? FavoriteMovie
        }
    }
}

