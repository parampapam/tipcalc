//
//  TipCalcModel.swift
//  TipCalc
//
//  Created by Роман Поспелов on 09.11.2020.
//
//  MVVM pattern: data model.
//

import Foundation


struct TipCalcModel {

    // Invoice amount for calculation of the tip and total amount
    var invoiceAmount = 0.0

    // Count of persons for calculation. This value will be saved when the new value
    // set and restored on startup this app
    @UserDefault(key: "countOfPersons", initialValue: 2) var countOfPersons: Int  {
        didSet {
            if countOfPersons < 2 {
                countOfPersons = 2
            }
        }
    }

    // The factor for calculation the tip (10%, 15%, 20%, etc.). This value will be saved
    // when the new value set and restored on startup this app
    @UserDefault(key: "tipFactor", initialValue: 0.1) var tipFactor: Double

    // The tip amount
    var tipAmount: Double {
        invoiceAmount * tipFactor
    }

    // The total amount - invoice amount and tip amount
    var totalAmount: Double {
        get {
            invoiceAmount + tipAmount
        }
    }

    // The tip per person
    var tipAmountPerPerson: Double {
        countOfPersons > 0 ? tipAmount / Double(countOfPersons) : 0
    }

    // The total amount per person
    var totalAmountPerPerson: Double {
        countOfPersons > 0 ? totalAmount / Double(countOfPersons) : 0
    }
}
