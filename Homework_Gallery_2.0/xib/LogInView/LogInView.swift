//
//  LogInView.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.06.21.
//

import UIKit

@IBDesignable
class LogInView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable var borberColor: UIColor {
        get {
            if let cgColor = self.layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return UIColor.white
            }
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

    var logInAction: (() -> Void)?
    var signUpAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        if let logInAction = logInAction {
            logInAction()
        }
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        if let signUpAction = signUpAction {
            signUpAction()
        }
    }

    private func setup() {
        Bundle(for: LogInView.self).loadNibNamed(String(describing: LogInView.self), owner: self, options: [:])
        logInButton.layer.cornerRadius = 5
        borderWidth = 0.5
        borberColor = UIColor.darkGray
        cornerRadius = 10
        loginTextField.delegate = self
        passwordTextField.delegate = self
        #if TARGET_INTERFASE_BUILDER
        contentView.frame = self.bounds
        self.addSubview(contentView)
        #else
        contentView.fixInContainer(self)
        #endif
    }
    
    func clearAllValues() {
        errorLabel.text = ""
        loginTextField.text = ""
        passwordTextField.text = ""
    }
}

extension LogInView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            if let logInAction = logInAction {
                logInAction()
            }
        }
        return true
    }

}
