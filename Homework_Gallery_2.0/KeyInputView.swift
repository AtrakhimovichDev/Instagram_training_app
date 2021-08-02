//
//  KeyInputView.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 29.07.21.
//

import UIKit

class KeyInputView: UIView {
    override var canBecomeFirstResponder: Bool { return true }
    override var canResignFirstResponder: Bool { return true }
}

extension KeyInputView: UIKeyInput {
    var hasText: Bool { return false }
    func insertText(_ text: String) {}
    func deleteBackward() {}
}
