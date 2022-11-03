//
//  GenreCell.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 1.11.2022.
//

import UIKit

class GenreCell: UICollectionViewCell {
    @IBOutlet weak var genreTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = bgView.frame.height / 5
    }
    func setup(title: String){
        genreTitle.text = title
    }

}
