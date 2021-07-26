//
//  Image.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import Foundation

class Image: Codable {
    var imageName: String
    var folder: String
    var location: String
    var date: Date
    var ownerUsername: String
    var usersLikes = [User]()
    private var comments = [Comment]()
    
    internal init(imageName: String, folder: String, location: String, date: Date, ownerUsername: String) {
        self.imageName = imageName
        self.folder = folder
        self.location = location
        self.date = date
        self.ownerUsername = ownerUsername
    }
}
