//
//  HorizontalCell.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 1.11.2022.
//

import UIKit

class VerticalCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(data: MovieCellProtocol?){
        movieImageView.sd_setImage(with: URL(string: data?.posterImage ?? ""))
        titleLabel.text = data?.titleText ?? ""
        starLabel.text = "\(data?.star ?? "")/10 IMDb"
    }
    func setup(title: String?, imageURL: String?, genres: [String]?, rate: Double? ){
        movieImageView.sd_setImage(with: URL(string: imageURL ?? ""))
        titleLabel.text = title ?? ""
        starLabel.text = "\(rate ?? 0)/10 IMDb"
        //self.genres = genres ?? []
        //genreCollectionView.reloadData()
    }
}
