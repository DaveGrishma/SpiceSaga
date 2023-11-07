//
//  RecipeBookListHeader.swift
//  SpiceSaga
//
//  Created by psagc on 07/11/23.
//

import UIKit

class RecipeBookListHeader: UIView {

   
    static var shared: RecipeBookListHeader {
        (UINib(nibName: "RecipeBookListHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? RecipeBookListHeader)!
    }

}
