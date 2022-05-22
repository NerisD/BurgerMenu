//
//  BurgerCustomViewCell.swift
//  BurgerMenu_App
//
//  Created by Dimitri SMITH on 22/05/2022.
//

import Foundation
import UIKit

class BurgerCustomViewCell: UITableViewCell {
    
    @IBOutlet weak var burgerImage: UIImageView!
    @IBOutlet weak var burgerTitle: UILabel!
    @IBOutlet weak var burgerDescription: UILabel!
    @IBOutlet weak var burgerPrice: UILabel!
    
    var price: String = ""
    
    
    
    
}
