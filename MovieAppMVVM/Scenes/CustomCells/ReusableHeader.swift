//
//  ReusableHeader.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 1.11.2022.
//

import UIKit

class ReusableHeader: UICollectionReusableView {

    @IBOutlet weak var titleText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(title: String){
        titleText.text = title
    }
    
}
