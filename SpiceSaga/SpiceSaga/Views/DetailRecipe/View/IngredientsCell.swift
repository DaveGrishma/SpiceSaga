//
//  IngredientsCell.swift
//  SpiceSaga
//
//  Created by psagc on 28/11/23.
//

import UIKit
import FirebaseStorage
import Kingfisher

class IngredientsCell: UICollectionViewCell {

    @IBOutlet private weak var imageViewIngredients: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var ingredientImage: String?{
        didSet {
            guard let imageUrlString = ingredientImage else { return  }
            let storageRef = Storage.storage().reference().child(imageUrlString)
            storageRef.downloadURL { (url, error) in
                self.imageViewIngredients.kf.setImage(with: url)
            }
        }
    }
}
