//
//  MainCVC.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.
//

import UIKit

class MainCVC: UICollectionViewCell {

    @IBOutlet weak var imgSearch: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    func fillCell(with image: UIImage) {
        imgSearch.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imgSearch.image = nil
    }
}
