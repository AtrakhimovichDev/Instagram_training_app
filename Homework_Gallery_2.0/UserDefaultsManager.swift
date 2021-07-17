//
//  UserDefaultsManager.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.06.21.
//

import Foundation

class UserDefaultsManager {
    
    private static var userSettingsArray: [UserSettings] = []
    
    static func saveUserDefaults(key: DefaultsKeys, value: Any?) {
        let userDefaults = UserDefaults.standard
        var data: Data?
        switch key {
        case .userSettings:
            let userSettingsArr = getUserDefaults(key: key) as? [UserSettings]
            if let curentUserSettingsArr = userSettingsArr {
                userSettingsArray = curentUserSettingsArr
                userSettingsArray.append(value as! UserSettings)
            } else {
                userSettingsArray = [value as! UserSettings]
            }
            data = try? JSONEncoder().encode(userSettingsArray)
        }
        if let savingData = data {
            userDefaults.setValue(savingData, forKey: key.rawValue)
        }
    }
    
    static func getUserDefaults(key: DefaultsKeys) -> Any? {
        let userDefaults = UserDefaults.standard
        let data = userDefaults.value(forKey: key) as? Data
        switch key {
        case .userSettings:
            if let convertedData = data {
                let result = try? JSONDecoder().decode([UserSettings].self, from: convertedData)
                return result
            } else {
                return nil
            }
        }
    }
    
}
