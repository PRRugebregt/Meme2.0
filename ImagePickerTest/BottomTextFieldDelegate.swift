//
//  BottomTextFieldDelegate.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 12/15/21.
//

import Foundation
import UIKit

protocol MoveUIOfViewController {
    func moveViewUp(by amount: CGFloat)
    func moveViewDown(by amount: CGFloat)
}

class BottomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var delegate : MoveUIOfViewController?
    var keyboardHeight : CGFloat = 0
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewUp), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewUp), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func moveViewUp(_ notification: Notification) {
        let userInfo = notification.userInfo
        if let keyboardFrame: NSValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
            if notification.name == UIResponder.keyboardDidShowNotification {
                delegate?.moveViewUp(by: self.keyboardHeight)
            } else {
                delegate?.moveViewDown(by: self.keyboardHeight)
            }
        }
    }
    
}
