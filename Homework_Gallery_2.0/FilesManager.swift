//
//  FilesManager.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 22.07.21.
//

import UIKit

class FilesManager {
    
    static let fileManager = FileManager.default
    
    static func getImage(image: Image) -> UIImage {
        let mainDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageDirectoryURL = mainDirectoryURL.appendingPathComponent("Images")
        let userImagesDirectory = imageDirectoryURL.appendingPathComponent(image.folder)
        let imageURL = userImagesDirectory.appendingPathComponent(image.imageName)
        
        if fileManager.fileExists(atPath: imageURL.path) {
            print(imageURL.path)
            return UIImage(contentsOfFile: imageURL.path) ?? UIImage()
        } else {
            return UIImage()
        }
    }
    
    static func getProfileImage(username: String) -> UIImage {
        let mainDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageDirectoryURL = mainDirectoryURL.appendingPathComponent("Images")
        let userImagesDirectory = imageDirectoryURL.appendingPathComponent(username)
        let imageURL = userImagesDirectory.appendingPathComponent("profileImage.png")
        
        if fileManager.fileExists(atPath: imageURL.path) {
            print(imageURL.path)
            return UIImage(contentsOfFile: imageURL.path) ?? UIImage()
        } else {
            return UIImage(named: "default_user_image") ?? UIImage()
        }
    }
    static func saveImage(in folder: URL, imageInfo: Image, image: UIImage) {
        guard let imageData = image.pngData() else {
            return
        }
        if fileManager.fileExists(atPath: folder.path) == false {
            try? fileManager.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: [:])
        }
        let userImagesDirectory = folder.appendingPathComponent(imageInfo.folder)
        if fileManager.fileExists(atPath: userImagesDirectory.path) == false {
            try? fileManager.createDirectory(atPath: userImagesDirectory.path, withIntermediateDirectories: true, attributes: [:])
        }
        let imageURl = userImagesDirectory.appendingPathComponent("\(imageInfo.imageName)")
        fileManager.createFile(atPath: imageURl.path, contents: imageData, attributes: [:])
    }
}
