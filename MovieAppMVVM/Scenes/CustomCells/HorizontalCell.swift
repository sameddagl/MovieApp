//
//  VerticalCell.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import UIKit
import SDWebImage

protocol MovieCellProtocol{
    var posterImage: String { get }
    var titleText: String { get }
    var star: String{ get }
    var genres: [String]{ get }
}

class HorizontalCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var starLabel: UILabel!
    
    var genres = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        genreCollectionView.dataSource = self
        genreCollectionView.register(UINib(nibName: K.genreCellXib, bundle: nil), forCellWithReuseIdentifier: K.genreCellIdentifier)
        genreCollectionView.collectionViewLayout = createLayout()
        movieImageView.layer.cornerRadius = movieImageView.frame.height / 10
    }
    func setup(data: MovieCellProtocol?){
        movieImageView.sd_setImage(with: URL(string: data?.posterImage ?? ""))
        textLabel.text = data?.titleText ?? ""
        starLabel.text = "\(data?.star ?? "")/10 IMDb"
        genres = data?.genres ?? []
    }
    func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionNum, env in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(30)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
        return layout
    }
}
extension HorizontalCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.genreCellIdentifier, for: indexPath) as! GenreCell
        cell.setup(title: genres[indexPath.row])
        return cell
    }
}
