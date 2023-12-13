//
//  AddedIngredientsCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 07/11/23.
//

import UIKit

class AddedIngredientsCell: UITableViewCell {

    @IBOutlet var imageViewIngredient: UIImageView!
    @IBOutlet var labelIngredientName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var detail: IngredientDetails? {
        didSet {
            guard let image = detail?.ingredientImage else { return  }
            imageViewIngredient.image = image
            labelIngredientName.text = detail?.name ?? ""
        }
    }
}
