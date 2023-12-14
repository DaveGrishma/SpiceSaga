//
//  IngredientsCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 28/11/23.
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
            self.imageViewIngredients.kf.indicatorType = .activity            
            guard let imageUrlString = ingredientImage else { return  }
            let storageRef = Storage.storage().reference().child(imageUrlString)
            storageRef.downloadURL { (url, error) in
                self.imageViewIngredients.kf.setImage(with: url)
            }
        }
    }
}
