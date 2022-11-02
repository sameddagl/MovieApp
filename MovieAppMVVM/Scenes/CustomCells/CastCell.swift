//
//  CastCell.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 1.11.2022.
//

import UIKit
import SDWebImage
protocol CastCellProtocol{
    var posterImage: String? { get }
    var nameLabel: String { get }
}


class CastCell: UICollectionViewCell {
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(data: CastCellProtocol?){
        let url = URL(string: "\(NetworkHelper.shared.imagePath)/\(data?.posterImage ?? "")")
        personImage.sd_setImage(with: url)
        nameLabel.text = data?.nameLabel
    }

}
