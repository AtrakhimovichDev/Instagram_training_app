//
//  UserDefaultsManager.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.06.21.
//

import Foundation

class UserDefaultsManager {
    
    private static var usersArray: [User] = []
    private static var imagesArray: [Image] = []
    
    static func getAllUsers(key: DefaultsKeys) -> [User]? {
        let userDefaults = UserDefaults.standard
        let data = userDefaults.value(forKey: key) as? Data
        if let convertedData = data {
            do {
                let result = try JSONDecoder().decode([User].self, from: convertedData)
                return result
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    static func getUser(identifier: UUID, key: DefaultsKeys) -> User? {
        if let allUsers = getAllUsers(key: key) {
            let findedUser = allUsers.filter({ $0.identifier == identifier })[0]
            return findedUser
        }
        return nil
    }
    
    static func getUser(login: String?, password: String?, key: DefaultsKeys) -> (User?, String) {
        if let allUsers = getAllUsers(key: key) {
            for curentUser in allUsers {
                if curentUser.username == login {
                    if curentUser.password == password {
                        return (curentUser, "")
                    } else {
                        return (nil, "Wrong password")
                    }
                }
            }
        }
        return (nil, "Technical difficulites")
    }
    
    static func getUsers(identifierArray: [UUID], key: DefaultsKeys) -> [User]? {
        if let allUsers = getAllUsers(key: key) {
            var usersResult: [User] = [User]()
            for user in allUsers {
                if identifierArray.contains(where: {$0 == user.identifier} ) {
                    usersResult.append(user)
                }
            }
            return usersResult
        }
        return nil
    }
    
    static func findSameLogin(login: String?, key: DefaultsKeys) -> Bool {
        if let allUsers = getAllUsers(key: key) {
            for curentUser in allUsers {
                if curentUser.username == login {
                    return true
                }
            }
        }
        return false
    }
    
    static func saveUserInfo(key: DefaultsKeys, user: User) {
        let userDefaults = UserDefaults.standard

        if let allUsers = getAllUsers(key: key) {
            usersArray = allUsers.filter( {$0.identifier != user.identifier})
            usersArray.append(user)
        } else {
            usersArray = [user]
        }

        do {
            let data = try JSONEncoder().encode(usersArray)
            userDefaults.setValue(data, forKey: key.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private static func getAllImages(key: DefaultsKeys) -> [Image] {
        let userDefaults = UserDefaults.standard
        let data = userDefaults.value(forKey: key) as? Data
        if let convertedData = data {
            do {
                let result = try JSONDecoder().decode([Image].self, from: convertedData)
                return result
            } catch {
                print(error.localizedDescription)
                return [Image]()
            }
        }
        return [Image]()
    }
    
    static func getImages(usersUUID: [UUID], key: DefaultsKeys) -> [Image] {
        let allImages = getAllImages(key: key)
        var imagesArrayResult = [Image]()
        for image in allImages {
            if usersUUID.contains(image.ownerIdentifier) && image.imageName != "profileImage.png" {
                imagesArrayResult.append(image)
            }
        }
        return imagesArrayResult
    }
    
    static func getImage(imageUUID: UUID, key: DefaultsKeys) -> Image {
        let allImages = getAllImages(key: key)
        let image = allImages.filter( {$0.identifier == imageUUID})[0]
        return image
    }
    
    static func saveImage(image: Image, key: DefaultsKeys) {
        let userDefaults = UserDefaults.standard

        let allImages = getAllImages(key: key)
        if allImages.count == 0 {
            imagesArray = [image]
        } else {
            imagesArray = allImages.filter( {$0.identifier != image.identifier})
            imagesArray.append(image)
        }
            
        do {
            let data = try JSONEncoder().encode(imagesArray)
            userDefaults.setValue(data, forKey: key.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
}
