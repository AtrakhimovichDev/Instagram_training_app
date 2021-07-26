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
    private var usersArray: [User]? = nil
        
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
        success = checkSameLogin(login: signUpView.loginTextField.text!)
        if !success {
            return success
        }
        signUpView.errorLabel.text = ""
        let user = User(username: signUpView.loginTextField.text!,
                        password: signUpView.passwordTextField.text!,
                        phone: signUpView.phoneTextField.text!,
                        fullName: signUpView.fullNameTextField.text!)
        success = UsersManager.saveUserInfo(key: .user, value: user)
        return success
    }
    
    private func checkSameLogin(login: String) -> Bool {
        usersArray = UsersManager.getUserInfo(key: .user) as? [User]
        if let curentUsersArray = usersArray {
            for curentUser in curentUsersArray {
                if curentUser.username == login {
                    signUpView.errorLabel.text = "User with this name exists"
                    return false
                }
            }
        }
        return true
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
        
        guard let fullName = signUpView.fullNameTextField.text else{
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
        usersArray = UsersManager.getUserInfo(key: .user) as? [User]
        var errorMessage = "No such account exists"
        if let curentUsersArray = usersArray {
            for curentUser in curentUsersArray {
                if curentUser.username == logInView.loginTextField.text {
                    if curentUser.password == logInView.passwordTextField.text {
                        errorMessage = ""
                        openGallery(user: curentUser)
                    } else {
                        errorMessage = "Wrong password"
                        break
                    }
                }
            }
        }
        logInView.errorLabel.text = errorMessage
    }
    
    private func openGallery(user: User) {
        let identifier = String(describing: GalleryViewController.self)
        let controller = ViewControllersFactory.createGalleryViewController(identifier: identifier, user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
