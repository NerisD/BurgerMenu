//
//  Burger.swift
//  BurgerMenu_App
//
//  Created by Dimitri SMITH on 21/05/2022.
//

import Foundation

struct Burger: Codable {
    var ref: String?
    var title: String?
    var description: String?
    var thumbnail: URL?
    var price: Int?
}
