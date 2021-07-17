//
//  UserDefaults+enum.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 16.06.21.
//

import Foundation

extension UserDefaults {
    
    func value(forKey key: DefaultsKeys) -> Any? {
        return value(forKey: key.rawValue)
    }
}
