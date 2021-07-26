//
//  User.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import Foundation

class User: Codable {
    var username: String
    var password: String
    var images = [Image]()
    var friends = [User]()
    private var phone: String
    private var fullName: String
    
    internal init(username: String, password: String, phone: String, fullName: String) {
        self.username = username
        self.password = password
        self.phone = phone
        self.fullName = fullName
    }
}
