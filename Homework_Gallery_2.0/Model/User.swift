//
//  User.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import Foundation

class User: Codable {
    var identifier: UUID
    var username: String
    var password: String
    var images = [UUID]()
    var friends = [UUID]()
    private var phone: String
    private var fullName: String
    
    internal init(identifier: UUID, username: String, password: String, phone: String, fullName: String) {
        self.identifier = identifier
        self.username = username
        self.password = password
        self.phone = phone
        self.fullName = fullName
    }
}
