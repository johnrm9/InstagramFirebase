//
//  SignUpController.swift
//  InstagramFirebase
//
//  Created by John Martin on 12/17/17.
//  Copyright © 2017 John Martin. All rights reserved.
//

import GestureRecognizerClosures
import UIKit

class SignUpController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
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

    lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes1: [NSAttributedStringKey: Any]? = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.buttonFontSize), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        let attributes2: [NSAttributedStringKey: Any]? = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize), NSAttributedStringKey.foregroundColor: UIColor.darkBlue]
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: attributes1)
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: attributes2))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.onTap { [unowned self] (_) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        clearInputTextFields()

        view.addSubviews(alreadyHaveAccountButton, plusPhotoButton)

        alreadyHaveAccountButton.anchor(leftAnchor: view.leftAnchor, bottomAnchor: view.bottomAnchor, rightAnchor: view.rightAnchor, height: 50)

        plusPhotoButton.anchor(topAnchor: view.topAnchor, paddingTop: 40, width: 140, height: 140, centerXAnchor: view.centerXAnchor)

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
    @discardableResult func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if isFormValid() { handleSignUp(signUpButton) }

        if textField == self.emailTextField {
            self.usernameTextField.becomeFirstResponder()
        } else if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.emailTextField.becomeFirstResponder()
        }

        return true
    }

    func clearInputTextFields() {
        emailTextField.text = nil
        usernameTextField.text = nil
        passwordTextField.text = nil

        signUpButtonIsEnabled(false)

        textFieldShouldReturn(passwordTextField)
    }

    func setPlusPhotoButtonStyleWithReset(_ reset: Bool = false) {
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = reset ? UIColor.clear.cgColor : UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        if reset { plusPhotoButton.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal) }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        setPlusPhotoButtonStyleWithReset()

        dismiss(animated: true)
    }

}

extension SignUpController {
    // MARK: - Handlers

    func signUpButtonIsEnabled(_ isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
        signUpButton.backgroundColor = signUpButton.isEnabled ? .darkBlue : .lightBlue
    }

    fileprivate func isFormValid() -> Bool {
        guard let email = emailTextField.text else { return false}
        guard let username = usernameTextField.text else { return false }
        guard let password = passwordTextField.text else { return false }

        let isEmailValid = email.isEmail
        let isUsernameValid = usernameTextField.hasText || username.length > 0
        let isPasswordValid = passwordTextField.hasText || password.length > 0

        let isFormValid = isEmailValid && isUsernameValid && isPasswordValid

        return isFormValid
    }

    @objc func handleTextInputChange(_ sender: UITextField) {
        signUpButtonIsEnabled(isFormValid())
    }

    @objc func handlePlusPhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        present(imagePickerController, animated: true)
    }

    @objc func handleSignUp(_ sender: UIButton) {
        defer {
            clearInputTextFields()
            //setPlusPhotoButtonStyleWithReset(true)
        }
        guard let email = emailTextField.text, email.length > 0 else { return }
        guard let username = usernameTextField.text, username.length > 0 else { return }
        guard let password = passwordTextField.text, password.length > 0 else { return }

        Service.shared.createUser(withEmail: email, password: password) { (uid, error) in
            guard error == nil else { return }
            guard let uid = uid else { return }

            print("Successfully created user:", uid)

            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }

            Service.shared.uploadProfileImage(uploadData: uploadData) { (profileImageUrl, error) in
                guard error == nil else { return }
                guard let profileImageUrl = profileImageUrl else { return }

                print("Successfully uploaded profile image:", profileImageUrl)

                let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                let values = [uid: dictionaryValues]
                Service.shared.updateUsers(values: values) { (error) in
                    guard error == nil else { return }
                    print("Successfully saved user info to db")

                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()

                    self.dismiss(animated: true)
                }
            }
        }
    }
}
