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
    private var usersArray: [User]?
        
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
            let success = self.saveUserSettings()
            if success {
                self.signUpView.removeFromSuperview()
                self.logInView.fixInContainer(self.contentView)
                self.logInView.clearAllValues()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logInView.clearAllValues()
        signUpView.clearAllValues()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func saveUserSettings() -> Bool {
        var success = checkFieldsFilling()
        if !success {
            return success
        }
        success = UserDefaultsManager.findSameLogin(login: signUpView.loginTextField.text, key: .user)
        if success {
            return success
        }
        signUpView.errorLabel.text = ""
        let user = User(identifier: UUID(),
                        username: signUpView.loginTextField.text!,
                        password: signUpView.passwordTextField.text!,
                        phone: signUpView.phoneTextField.text!,
                        fullName: signUpView.fullNameTextField.text!)
        UserDefaultsManager.saveUserInfo(key: .user, user: user)
        return success
    }
    
    private func checkFieldsFilling() -> Bool {
        guard let phone = signUpView.phoneTextField.text else {
            signUpView.errorLabel.text = "Fill phone field"
            return false
        }
        if phone.isEmpty {
            signUpView.errorLabel.text = "Fill phone field"
            return false
        }
        
        guard let fullName = signUpView.fullNameTextField.text else {
            signUpView.errorLabel.text = "Fill full name field"
            return false
        }
        if fullName.isEmpty {
            signUpView.errorLabel.text = "Fill full name field"
            return false
        }
        
        guard let login = signUpView.loginTextField.text else {
            signUpView.errorLabel.text = "Fill login field"
            return false
        }
        if login.isEmpty {
            signUpView.errorLabel.text = "Fill login field"
            return false
        }
        
        guard let password = signUpView.passwordTextField.text else {
            signUpView.errorLabel.text = "Fill password field"
            return false
        }
        if password.isEmpty {
            signUpView.errorLabel.text = "Fill password field"
            return false
        }
        return true
    }
    
    private func checkLoginAndPassword() {
        let userTuple = UserDefaultsManager.getUser(login: logInView.loginTextField.text,
                                               password: logInView.passwordTextField.text,
                                               key: .user)
        logInView.errorLabel.text = userTuple.1
        if let user = userTuple.0 {
            openGallery(user: user)
        }
    }
    
    private func openGallery(user: User) {
        let identifier = String(describing: GalleryViewController.self)
        let controller = ViewControllersFactory.createGalleryViewController(identifier: identifier, user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
