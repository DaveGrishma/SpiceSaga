//
//  RecipeBookTableViewCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 05/11/23.
//

import UIKit
import Kingfisher
import FirebaseStorage
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
            guard let userImage = recipeDetails?.userID, let recipeThumb = recipeDetails?.thumbUrl else { return  }
            
            
//            imageViewUserProfile.kf.setImage(with: userUrl)
            labelRecipeName.text = recipeDetails?.name ?? ""
            labelRecipeType.text = recipeDetails?.type ?? ""
            
            let storageRef = Storage.storage().reference().child(recipeThumb)
            storageRef.downloadURL { (url, error) in
                self.imageViewRecipeThumb.kf.setImage(with: url)
            }
            
            FirebaseRealTimeStorage.shared.getProfilePictureURL(forUserID: userImage) { url in
                if let userUrl = url {
                    self.imageViewUserProfile.kf.setImage(with: userUrl)
                }
            }
        }
    }
}
