//
//  ViewController.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 16.06.21.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    private let userDefaults = UserDefaults.standard
    private var userSettings: UserSettings?
    private let fileManager = FileManager.default
    private lazy var cachesFolderURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    private lazy var imagesFolderURL = cachesFolderURL.appendingPathComponent("images")
    private var logIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readUserSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !logIn {
            showHelloAlert()
        }
    }
    
    @IBAction func pickPhotoButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController(title: "Choose media source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Media library", style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if self.checkCameraPermissions() {
                picker.sourceType = .camera
                self.present(picker, animated: true)
            } else {
                self.showErrorAlert()
            }
        }))
        present(alert, animated: true)
    }
    
    func checkCameraPermissions() -> Bool {
        #if targetEnvironment(simulator)
        return false // На симуляторе камера не работает, даже не будем пробовать запускать
        #else
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined, .authorized:
            return true
        default:
            return false
        }
        #endif
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "No persmissions for camera usage, check device app settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func readUserSettings() {
        if let userSettingsData = userDefaults.value(forKey: DefaultsKeys.userSettings.rawValue) as? Data {
            self.userSettings = try? JSONDecoder().decode(UserSettings.self, from: userSettingsData)
        }
    }

    private func saveSettings() {
        if let userSettings = userSettings {
            let userSettingsData = try? JSONEncoder().encode(userSettings)
            userDefaults.setValue(userSettingsData, forKey: DefaultsKeys.userSettings.rawValue)
        }
    }
    
    private func showHelloAlert() {
        if let userSettings = userSettings {
            showAlert(alertType: .password, userSettings: userSettings)
        } else {
//            userSettings = UserSettings(login: "", password: "")
//            showAlert(alertType: .newUser, userSettings: userSettings!)
        }
    }
    
    func showAlert(alertType: AlertType, userSettings: UserSettings) {
        var alert = UIAlertController()
        switch alertType {
        case .newUser:
            alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.title = "Hello new user!"
            alert.message = "Enter your new login and password."
            alert.addTextField { textField in
                textField.placeholder = "Enter login"
            }
            alert.addTextField { textField in
                textField.isSecureTextEntry = true
                textField.placeholder = "Enter password"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                userSettings.login = alert.textFields?[0].text ?? ""
                userSettings.password = alert.textFields?[1].text ?? ""
                self.saveSettings()
                self.logIn = true
            }))
        case .password:
            alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.title = "Hello \(userSettings.login)!"
            alert.message = "Enter your password."
            alert.addTextField { textField in
                textField.isSecureTextEntry = true
                textField.placeholder = "Password"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                let enteredPassword = alert.textFields?[0].text ?? ""
                if enteredPassword != userSettings.password {
                    let newAlert = UIAlertController(title: "Ops...", message: "Wrong password!", preferredStyle: .alert)
                    newAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                        self.showAlert(alertType: .password, userSettings: self.userSettings!)
                    }))
                    newAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.present(newAlert, animated: true)
                } else {
                    self.logIn = true
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                
            }))
        case .galleryMode:
            print(1)
        }
        present(alert, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let image = info[.editedImage] as? UIImage
        let imageData = image?.pngData()
        if fileManager.fileExists(atPath: imagesFolderURL.path) == false {
            try? fileManager.createDirectory(atPath: imagesFolderURL.path, withIntermediateDirectories: true, attributes: [:])
        }
        let imageURl = imagesFolderURL.appendingPathComponent("\(Int(Date().timeIntervalSince1970)).png")
        fileManager.createFile(atPath: imageURl.path, contents: imageData, attributes: [:])
        picker.dismiss(animated: true)
        
    }
}

