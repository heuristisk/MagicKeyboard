//
//  KeyboardScrollView.swift
//  MagicKeyboard
//
//  Created by Anderson Santos Gusmão on 23/03/2018.
//  Copyright © 2018 Anderson Santos Gusmão. All rights reserved.
//

import UIKit

@IBDesignable
final class KeyboardScrollView: UIScrollView {

    private var keyboardIsPresented = false

    @IBInspectable
    var extraBottomSpace: CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if keyboardIsPresented == false {
            keyboardIsPresented = true
            adjustInsetForKeyboardShow(show: keyboardIsPresented, notification: notification)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if keyboardIsPresented == true {
            keyboardIsPresented = false
            adjustInsetForKeyboardShow(show: keyboardIsPresented, notification: notification)
        }
    }

    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let adjustment = (keyboardFrame.cgRectValue.height + extraBottomSpace) * (show ? 1 : -1)
        contentInset.bottom += adjustment
        scrollIndicatorInsets.bottom += adjustment
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
