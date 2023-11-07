//
//  RecipeStepsCell.swift
//  SpiceSaga
//
//  Created by psagc on 07/11/23.
//

import UIKit

class RecipeStepsCell: UITableViewCell {

    @IBOutlet private var labelStep: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var step: String? {
        didSet {
            labelStep.text = step ?? ""
        }
    }
}
