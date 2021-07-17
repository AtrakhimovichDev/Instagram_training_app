//
//  LogInViewController.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.06.21.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    private let logInView = LogInView()
    private let signUpView = SignUpView()
    private var userSettingsArray: [UserSettings]? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()

        logInView.fixInContainer(contentView)
        
        logInView.logInAction = {
            self.checkLoginAndPassword()
        }
        
        logInView.signUpAction = {
            self.logInView.removeFromSuperview()
            self.signUpView.fixInContainer(self.contentView)
            self.signUpView.clearAllValues()
            self.view.layoutIfNeeded()
        }
        
        signUpView.logInAction = {
            self.signUpView.removeFromSuperview()
            self.logInView.fixInContainer(self.contentView)
            self.logInView.clearAllValues()
            self.view.layoutIfNeeded()
        }
        
        signUpView.signUpAction = {
            self.saveUserSettings()
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logInView.clearAllValues()
        signUpView.clearAllValues()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func saveUserSettings() {
        guard let phone = signUpView.phoneTextField.text else {
            signUpView.errorLabel.text = "Fill phone field"
            return
        }
        if phone.isEmpty {
            signUpView.errorLabel.text = "Fill phone field"
            return
        }
        
        guard let fullName = signUpView.fullNameTextField.text else{
            signUpView.errorLabel.text = "Fill full name field"
            return
        }
        if fullName.isEmpty {
            signUpView.errorLabel.text = "Fill full name field"
            return
        }
        
        guard let login = signUpView.loginTextField.text else {
            signUpView.errorLabel.text = "Fill login field"
            return
        }
        if login.isEmpty {
            signUpView.errorLabel.text = "Fill login field"
            return
        }
        
        guard let password = signUpView.passwordTextField.text else {
            signUpView.errorLabel.text = "Fill password field"
            return
        }
        if password.isEmpty {
            signUpView.errorLabel.text = "Fill password field"
            return
        }
        signUpView.errorLabel.text = ""
        let userSettings = UserSettings(phone: phone, fullName: fullName, login: login, password: password)
        UserDefaultsManager.saveUserDefaults(key: .userSettings, value: userSettings)
    }
   
    private func checkLoginAndPassword() {
        userSettingsArray = UserDefaultsManager.getUserDefaults(key: .userSettings) as? [UserSettings]
        var errorMessage = "No such account exists"
        if let curentUserSettingsArray = userSettingsArray {
            for curentUserSettings in curentUserSettingsArray {
                if curentUserSettings.login == logInView.loginTextField.text {
                    if curentUserSettings.password == logInView.passwordTextField.text {
                        errorMessage = ""
                        openGallery()
                    } else {
                        errorMessage = "Wrong password"
                        break
                    }
                }
            }
        }
        logInView.errorLabel.text = errorMessage
    }
    
    private func openGallery() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let galleryVC = storyboard.instantiateViewController(identifier: String(describing: GalleryViewController.self))
        navigationController?.pushViewController(galleryVC, animated: true)
    }
}
