//
//  FavoriteMovieCell.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 4.11.2022.
//

import UIKit
import SDWebImage

class FavoriteMovieCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(title: String, imageURL: String, rate: Double ){
        movieImageView.sd_setImage(with: URL(string: NetworkHelper.shared.imagePath + imageURL))
        titleLabel.text = title
        rateLabel.text = "\(rate)/10 IMDb"

    }

}
