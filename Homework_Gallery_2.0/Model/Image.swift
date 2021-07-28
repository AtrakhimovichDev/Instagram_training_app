//
//  Image.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import Foundation

class Image: Codable {
    var identifier: UUID
    var imageName: String
    var folder: String
    var location: String
    var date: Date
    var ownerIdentifier: UUID
    var usernamesLikes = [UUID]()
    private var comments = [Comment]()
    
    internal init(identifier: UUID, imageName: String, folder: String, location: String, date: Date, ownerUsername: UUID) {
        self.identifier = identifier
        self.imageName = imageName
        self.folder = folder
        self.location = location
        self.date = date
        self.ownerIdentifier = ownerUsername
    }
}
