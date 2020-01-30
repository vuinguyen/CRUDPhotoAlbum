//
//  CustomCollectionViewCell.swift
//  CRUDPhotoAlbum
//
//  Created by Adrian Bolinger on 1/30/20.
//  Copyright © 2020 SunfishEmpire. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        imageView.contentMode = .scaleAspectFit
//        guard let testName = image else { return }
//        imageView.image = testName
    }
    
    private func setup() {
        guard let testName = image else { return }
        imageView.image = testName
    }

}
