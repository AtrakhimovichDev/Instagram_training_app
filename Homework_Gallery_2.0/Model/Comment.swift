//
//  Comment.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import Foundation

class Comment: Codable {
    private var text: String
    private var date: Date
    private var user: User
    
    internal init(text: String, date: Date, user: User) {
        self.text = text
        self.date = date
        self.user = user
    }
}
