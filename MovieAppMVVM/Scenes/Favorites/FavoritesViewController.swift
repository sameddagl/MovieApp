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
    
    var savedMovies: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: K.verticalCellXib, bundle: nil), forCellWithReuseIdentifier: K.verticalCellIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteMovies()

    }
    
    func fetchFavoriteMovies(){

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
        return UICollectionViewCell()
    }
    
    
}
