//
//  UserDefaultsManager.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.06.21.
//

import Foundation

class UsersManager {
    
    private static var usersArray: [User] = []
    
    static func saveUserInfo(key: DefaultsKeys, value: Any?) -> Bool {
        var success = false
        let userDefaults = UserDefaults.standard
        var data: Data?
        switch key {
        case .user:
            let usersArr = getUserInfo(key: key) as? [User]
            let newUser = value as! User
            if let curentUsersArr = usersArr {
                usersArray = curentUsersArr
                usersArray = usersArray.filter { $0.username != newUser.username }
                usersArray.append(newUser)
            } else {
                usersArray = [newUser]
            }
            data = try? JSONEncoder().encode(usersArray)
        }
        if let savingData = data {
            userDefaults.setValue(savingData, forKey: key.rawValue)
            success = true
        }
        return success
    }
    
    static func getUserInfo(key: DefaultsKeys) -> Any? {
        let userDefaults = UserDefaults.standard
        let data = userDefaults.value(forKey: key) as? Data
        switch key {
        case .user:
            if let convertedData = data {
                let result = try? JSONDecoder().decode([User].self, from: convertedData)
                return result
            } else {
                return nil
            }
        }
    }
    
//    static func getUsersImages(key: DefaultsKeys, users: [User]) -> [Image] {
//        var result = [Image]()
//        if users.count == 0 {
//            return result
//        }
//        
//        guard let allUsers = getUserInfo(key: key) as? [User] else {
//            return result
//        }
//        
//        for user in users {
//            
//        }
//        
//        return result
//    }
    
}
