//
//  RecipeBookListHeader.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 07/11/23.
//

import UIKit

class RecipeBookListHeader: UIView {

    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var textFieldSearch: UITextField!
    
    var didSearch:((_ search: String) -> Void)?
    var didSelectedFilter:(() -> ())?
    
    static var shared: RecipeBookListHeader {
        (UINib(nibName: "RecipeBookListHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? RecipeBookListHeader)!
    }

    var userName: String? {
        didSet {
            labelUserName.text = "Hello, \(userName ?? "")"
        }
    }
    
    func setupPlaceHolderForSearch() {
        textFieldSearch.attributedPlaceholder = NSAttributedString(
            string: "Search..",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    // MARK: - Action Methods
    @IBAction private func didStartedSearch(sender: UITextField) {
        didSearch?(sender.text ?? "")
    }
    
    @IBAction private func didTapOnFilter() {
        didSelectedFilter?()
    }
}
