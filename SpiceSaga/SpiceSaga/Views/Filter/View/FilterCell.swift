//
//  FilterCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 11/12/23.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet private var labelFilterValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    var filter: FilterType? {
        didSet {
            labelFilterValue.text = filter?.displayValue ?? ""
        }
    }
}
