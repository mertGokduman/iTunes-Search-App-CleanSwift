//
//  CollectionViewHeaderReusableView.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.
//

import UIKit

class CollectionViewHeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillHeader(with title: String) {
        lblHeaderTitle.text = title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
