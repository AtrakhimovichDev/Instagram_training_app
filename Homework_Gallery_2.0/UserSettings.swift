//
//  UserSettings.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 16.06.21.
//

import Foundation

class UserSettings: Codable {
    var phone: String
    var fullName: String
    var login: String
    var password: String
    
    internal init(phone: String, fullName: String, login: String, password: String) {
        self.phone = phone
        self.fullName = fullName
        self.login = login
        self.password = password
    }
}
