//
//  SettingsCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 11/12/23.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet private var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var settings: Settiings?{
        didSet {
            labelTitle.text = settings?.name.title ?? ""
        }
    }
}
