//
//  SignUpView.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.06.21.
//

import UIKit

@IBDesignable
class SignUpView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var logInAction: (() -> ())?
    var signUpAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        Bundle(for: SignUpView.self).loadNibNamed(String(describing: SignUpView.self), owner: self, options: [:])
        phoneTextField.delegate = self
        fullNameTextField.delegate = self
        loginTextField.delegate = self
        passwordTextField.delegate = self
        #if TARGET_INTERFACE_BUILDER
        contentView.frame = self.bounds
        self.addSubview(contentView)
        #else
        contentView.fixInContainer(self)
        #endif
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.borderWidth = 0.5

        signUpButton.layer.cornerRadius = 5
    }
    
    func clearAllValues() {
        errorLabel.text = ""
        phoneTextField.text = ""
        fullNameTextField.text = ""
        loginTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func clearDefaultsButtonPressed(_ sender: Any) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if let signUpAction = signUpAction {
            signUpAction()
        }
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        if let logInAction = logInAction {
            logInAction()
        }
    }
}

extension SignUpView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneTextField:
            fullNameTextField.becomeFirstResponder()
        case fullNameTextField:
            loginTextField.becomeFirstResponder()
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }

}
