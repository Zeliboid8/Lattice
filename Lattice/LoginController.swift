//
//  LoginController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/5/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class LoginController: UIViewController, UITextFieldDelegate {

    var radialGradient: RadialGradientView!
    var titleLabel: UILabel!
    var logo: UIImageView!
    var emailIcon: UIImageView!
    var emailTextField: UITextField!
    var passwordIcon: UIImageView!
    var passwordTextField: UITextField!
    var signInButton: UIButton!
    var createAccountButton: UIButton!
    
    let logoHeight: CGFloat = 260
    let buttonHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        titleLabel = UILabel()
        titleLabel.text = "Lattice"
        titleLabel.textColor = Colors.labelColor
        titleLabel.font = UIFont(name: "Offside-Regular", size: 45)
        view.addSubview(titleLabel)
        
        logo = UIImageView()
        logo.image = UIImage(named: "Logo")
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
        
        emailIcon = UIImageView()
        emailIcon.image = UIImage(named: "Mail")
        view.addSubview(emailIcon)
        
        emailTextField = UITextField()
        emailTextField.textColor = Colors.labelColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedString.Key.foregroundColor: Colors.labelColor])
        emailTextField.font = UIFont(name: "Nunito-Semibold", size: 18)
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        passwordIcon = UIImageView()
        passwordIcon.image = UIImage(named: "Lock")
        view.addSubview(passwordIcon)
        
        passwordTextField = UITextField()
        passwordTextField.textColor = Colors.labelColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor: Colors.labelColor])
        passwordTextField.font = UIFont(name: "Nunito-Semibold", size: 18)
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        signInButton = UIButton()
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        signInButton.backgroundColor = Colors.red
        signInButton.layer.cornerRadius = buttonHeight / 2
        signInButton.layer.shadowColor = Colors.shadowColor
        signInButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        signInButton.layer.shadowOpacity = 0.8
        signInButton.layer.masksToBounds = false
        signInButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(signInButton)
        
        createAccountButton = UIButton()
        createAccountButton.setTitle("Create an account", for: .normal)
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        createAccountButton.backgroundColor = Colors.blue
        createAccountButton.layer.cornerRadius = buttonHeight / 2
        createAccountButton.layer.shadowColor = Colors.shadowColor
        createAccountButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        createAccountButton.layer.shadowOpacity = 0.8
        createAccountButton.layer.masksToBounds = false
        createAccountButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(createAccountButton)
        
        setupConstraints()
    }

    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        logo.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(logoHeight)
        }
        emailIcon.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(40)
            make.width.height.equalTo(20)
        }
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(emailIcon.snp.trailing).offset(30)
            make.trailing.equalTo(view).offset(-20)
            make.centerY.equalTo(emailIcon)
        }
        passwordIcon.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailIcon.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(40)
            make.width.height.equalTo(20)
        }
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(passwordIcon.snp.trailing).offset(30)
            make.trailing.equalTo(view).offset(-20)
            make.centerY.equalTo(passwordIcon)
        }
        signInButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.height.equalTo(buttonHeight)
            make.centerX.equalTo(view)
            make.leading.trailing.equalTo(view).inset(50)
        }
        createAccountButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.height.equalTo(buttonHeight)
            make.centerX.equalTo(view)
            make.leading.trailing.equalTo(view).inset(50)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
