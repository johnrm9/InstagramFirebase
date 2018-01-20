//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/8/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        view.addSubview(logoImageView)
        logoImageView.anchor(width: 200, height: 50, centerAnchored: true)
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
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

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .veryLightGray
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tag = 1
        textField.addTarget(self, action: #selector(handleTextInputChange(_:)), for: .editingChanged)
        return textField
    }()

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.lightBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        return button
    }()

    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedStringKey.foregroundColor: UIColor(r: 17, g: 154, b: 237), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp(_:)), for: .touchUpInside)
        return button
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        clearInputTextFields()

        view.backgroundColor = .white

        navigationController?.isNavigationBarHidden = true

        view.addSubview(logoContainerView)
        logoContainerView.anchor(topAnchor: view.topAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, height: 150)

        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(leftAnchor: view.leftAnchor, bottomAnchor: view.bottomAnchor, rightAnchor: view.rightAnchor, height: 50)

        setupInputFields()
    }

    func clearInputTextFields() {
        emailTextField.text = nil
        passwordTextField.text = nil

        loginButtonIsEnabled(false)

        textFieldShouldReturn(passwordTextField)
    }

    @discardableResult
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if isFormValid() { handleLogin(loginButton) }

        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.emailTextField.becomeFirstResponder()
        }

        return true
    }

    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])

        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)

        stackView.anchor(topAnchor: logoContainerView.bottomAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingRight: 40, height: 140)
    }

    func loginButtonIsEnabled(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.backgroundColor = loginButton.isEnabled ? .darkBlue : .lightBlue
    }

    fileprivate func isFormValid() -> Bool {
        guard let email = emailTextField.text else { return false}
        guard let password = passwordTextField.text else { return false }

        let isEmailValid = email.isEmail
        let isPasswordValid = passwordTextField.hasText || password.length > 0

        let isFormValid = isEmailValid && isPasswordValid

        return isFormValid
    }

    @objc func handleTextInputChange(_ sender: UITextField) {
        loginButtonIsEnabled(isFormValid())
    }

    @objc func handleLogin(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Service.shared.signIn(with: email, password: password) { (user, error) in
            guard error == nil else { return }
            print("Successfully logged back in with user:", user?.uid ?? "")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true)
        }
    }

    @objc func handleShowSignUp(_ sender: UIButton) {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
}
