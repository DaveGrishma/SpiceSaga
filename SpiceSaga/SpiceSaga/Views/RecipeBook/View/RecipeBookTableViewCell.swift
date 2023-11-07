//
//  RecipeBookTableViewCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 05/11/23.
//

import UIKit
import Kingfisher

class RecipeBookTableViewCell: UITableViewCell {

    @IBOutlet private var labelUserName: UILabel!
    @IBOutlet private var imageViewUserProfile: UIImageView!
    @IBOutlet private var imageViewRecipeThumb: UIImageView!
    @IBOutlet private var labelRecipeName: UILabel!
    @IBOutlet private var labelRecipeType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var recipeDetails: Recipe? {
        didSet {
            labelUserName.text = recipeDetails?.userName ?? ""
            guard let userImage = recipeDetails?.userProfileImage, let recipeThumb = recipeDetails?.thumbUrl else { return  }
            let userUrl = URL(string: userImage)
            let recipeThumbUrl = URL(string: recipeThumb)
            imageViewRecipeThumb.kf.setImage(with: recipeThumbUrl)
            imageViewUserProfile.kf.setImage(with: recipeThumbUrl)
            labelRecipeName.text = recipeDetails?.name ?? ""
            labelRecipeType.text = recipeDetails?.type ?? ""
            
        }
    }
}
