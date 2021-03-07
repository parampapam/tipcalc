//
//  UserDefaults.swift
//  TipCalc
//
//  Created by Роман Поспелов on 11.11.2020.
//

import Foundation

// Property wrapper for save and restore user values of properties.

@propertyWrapper
struct UserDefault<T> {
    var key: String
    var initialValue: T
    var wrappedValue: T {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { UserDefaults.standard.object(forKey: key) as? T ?? initialValue }
    }
}
