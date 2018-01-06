//
//  SignUpController.swift
//  InstagramFirebase
//
//  Created by John Martin on 12/17/17.
//  Copyright © 2017 John Martin. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto(_:)), for: .touchUpInside)
        return button
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .veryLightGray
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tag = 0
        textField.addTarget(self, action: #selector(handleTextInputChange(_:)), for: .editingChanged)
        return textField
    }()

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = .veryLightGray
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tag = 1
        textField.addTarget(self, action: #selector(handleTextInputChange(_:)), for: .editingChanged)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .veryLightGray
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tag = 2
        textField.addTarget(self, action: #selector(handleTextInputChange(_:)), for: .editingChanged)
        return textField
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .lightBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes1: [NSAttributedStringKey: Any]? = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.buttonFontSize), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        let attributes2: [NSAttributedStringKey: Any]? = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize), NSAttributedStringKey.foregroundColor: UIColor.darkBlue]
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: attributes1)
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: attributes2))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount(_:)), for: .touchUpInside)
        button.isEnabled = false // <--- Enable!!!
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubviews(alreadyHaveAccountButton, plusPhotoButton)

        alreadyHaveAccountButton.anchor(leftAnchor: view.leftAnchor, bottomAnchor: view.bottomAnchor, rightAnchor: view.rightAnchor, height: 50)

        plusPhotoButton.anchor(topAnchor: view.topAnchor, paddingTop: 40, width: 140, height: 140, centerXanchor: view.centerXAnchor)

        setupInputFields()
    }

    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])

        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)

        stackView.anchor(topAnchor: plusPhotoButton.bottomAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingRight: 40, height: 200)
    }

}

extension SignUpController {
    // MARK: - Handlers

    @objc func handleTextInputChange(_ sender: UITextField) {
        print(#function); print("TextField tag = \(sender.tag)")
        //signUpButtonIsEnabled(isFormValid())
    }

    @objc func handlePlusPhoto(_ sender: UIButton) {
        print(#function)
    }

    @objc func handleSignUp(_ sender: UIButton) {
        print(#function)
    }

    @objc func handleAlreadyHaveAccount(_ sender: UIButton) {
        print(#function)
    }
}
