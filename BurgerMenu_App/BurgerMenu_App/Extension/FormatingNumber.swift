//
//  FormatingNumber.swift
//  BurgerMenu_App
//
//  Created by Dimitri SMITH on 23/05/2022.
//

import Foundation

extension Int {
    func formatnumber() -> String {
        let formater = NumberFormatter()
        let convertToDouble = Float(self)
        let result = convertToDouble/100
        formater.usesGroupingSeparator = true
        formater.numberStyle = .currency
        formater.locale = Locale.current
        return formater.string(from: NSNumber(value: result))!
    }
}
