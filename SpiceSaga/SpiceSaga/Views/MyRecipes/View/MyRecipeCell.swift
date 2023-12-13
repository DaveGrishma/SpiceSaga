//
//  MyRecipeCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 07/11/23.
//

import UIKit
import Kingfisher
import FirebaseStorage

class MyRecipeCell: UITableViewCell {

    @IBOutlet private var labelType: UILabel!
    @IBOutlet private var labelName: UILabel!
    @IBOutlet private var labelDuration: UILabel!
    @IBOutlet private var labelClaories: UILabel!
    @IBOutlet private var imageViewRecipe: UIImageView!
    
    var didSelectedDelete:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var recipeDetails: Recipe?{
        didSet {
            labelType.text = recipeDetails?.type ?? ""
            labelName.text = recipeDetails?.name ?? ""
            labelDuration.text = recipeDetails?.duration ?? ""
            labelClaories.text = "\(recipeDetails?.calaroies ?? 0) Calories"
            guard let imageUrlString = recipeDetails?.thumbUrl else { return  }
            let storageRef = Storage.storage().reference().child(imageUrlString)
            storageRef.downloadURL { (url, error) in
                self.imageViewRecipe.kf.setImage(with: url)
            }
        }
    }
    
    @IBAction private func didTapOnDelete() {
        didSelectedDelete?()
    }
}
