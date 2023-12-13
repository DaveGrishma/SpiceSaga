//
//  MyRecipeHeaderView.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 07/11/23.
//

import UIKit

class MyRecipeHeaderView: UIView {

    
    var didSelectedAdd:(() -> Void)?
    
    static var shared: MyRecipeHeaderView {
        (UINib(nibName: "MyRecipeHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? MyRecipeHeaderView)!
    }

    @IBAction private func didTapOnAddButton() {
        didSelectedAdd?()
    }
}
