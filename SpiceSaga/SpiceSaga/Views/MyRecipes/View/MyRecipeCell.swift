//
//  MyRecipeCell.swift
//  SpiceSaga
//
//  Created by psagc on 07/11/23.
//

import UIKit
import Kingfisher

class MyRecipeCell: UITableViewCell {

    @IBOutlet private var labelType: UILabel!
    @IBOutlet private var labelName: UILabel!
    @IBOutlet private var labelDuration: UILabel!
    @IBOutlet private var labelClaories: UILabel!
    @IBOutlet private var imageViewRecipe: UIImageView!
    
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
            guard let imageUrlString = recipeDetails?.thumbUrl, let imageUrl = URL(string: imageUrlString) else { return  }
            imageViewRecipe.kf.setImage(with: imageUrl)
        }
    }
}
