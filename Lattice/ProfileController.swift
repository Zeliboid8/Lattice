//
//  ProfileController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/30/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class ProfileController: UIViewController {

    var menuBar: MenuBar!
    var radialGradient: RadialGradientView!
    var profilePhoto: UIImageView!
    var nameLabel: UILabel!
    var usernameLabel: UILabel!
    var qrCodeButton: UIButton!
    var emailStackView: UIStackView!
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var passwordStackView: UIStackView!
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var notificationsLabel: UILabel!
    var logoutButton: UIButton!
    
    let photoHeight: CGFloat = 120
    let buttonHeight: CGFloat = 50
    let menuBarHeight: CGFloat = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        view.addGestureRecognizer(tapToDismiss)
        
        menuBar = MenuBar()
        view.addSubview(menuBar)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        view.sendSubviewToBack(radialGradient)
        
        profilePhoto = UIImageView()
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = photoHeight / 2
        profilePhoto.image = UIImage(named: "ProfilePhoto")
        profilePhoto.clipsToBounds = true
        profilePhoto.contentMode = .scaleAspectFit
        
        nameLabel = UILabel()
        nameLabel.text = "Eli Zhang"
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 25)
        
        usernameLabel = UILabel()
        usernameLabel.text = "@elikzhang"
        usernameLabel.textColor = .white
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        
        qrCodeButton = UIButton()
        qrCodeButton.setTitle("My QR Code", for: .normal)
        qrCodeButton.setImage(UIImage(named: "QRCode"), for: .normal)
        qrCodeButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        qrCodeButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        qrCodeButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        qrCodeButton.imageView?.contentMode = .scaleAspectFit
        qrCodeButton.imageView?.clipsToBounds = true
        qrCodeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        qrCodeButton.setTitleColor(.white, for: .normal)
        qrCodeButton.contentMode = .center
        qrCodeButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        qrCodeButton.titleLabel?.textAlignment = .center
        qrCodeButton.backgroundColor = UIColor(red: 0.03, green: 0.85, blue: 0.84, alpha: 1)
        qrCodeButton.layer.cornerRadius = buttonHeight / 2
        qrCodeButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        qrCodeButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        qrCodeButton.layer.shadowOpacity = 0.8
        qrCodeButton.layer.masksToBounds = false
        
        emailLabel = UILabel()
        emailLabel.text = "EMAIL"
        emailLabel.textColor = .white
        emailLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        
        emailTextField = UITextField()
        emailTextField.text = "elikzhang@gmail.com"
        emailTextField.placeholder = "Email"
        emailTextField.textColor = .white
        emailTextField.font = UIFont(name: "Nunito-Regular", size: 18)
        
        emailStackView = UIStackView()
        emailStackView.axis = .horizontal
        emailStackView.distribution = .fill
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        passwordLabel = UILabel()
        passwordLabel.text = "PASSWORD"
        passwordLabel.textColor = .white
        passwordLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        
        passwordTextField = UITextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.text = "password123"
        passwordTextField.textColor = .white
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont(name: "Nunito-Regular", size: 18)
        
        passwordStackView = UIStackView()
        passwordStackView.axis = .horizontal
        passwordStackView.distribution = .fill
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        notificationsLabel = UILabel()
        notificationsLabel.text = "NOTIFICATIONS"
        notificationsLabel.textColor = .white
        notificationsLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        
        logoutButton = UIButton()
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        logoutButton.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.38, alpha: 1)
        logoutButton.layer.cornerRadius = buttonHeight / 2
        logoutButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        logoutButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        logoutButton.layer.shadowOpacity = 0.8
        logoutButton.layer.masksToBounds = false

        view.addSubview(profilePhoto)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(qrCodeButton)
        view.addSubview(emailStackView)
        view.addSubview(passwordStackView)
        view.addSubview(notificationsLabel)
        view.addSubview(logoutButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        menuBar.snp.makeConstraints { (make) -> Void in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(menuBarHeight)
        }
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        profilePhoto.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.height.width.equalTo(photoHeight)
            make.centerX.equalTo(view)
        }
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(profilePhoto.snp.bottom).offset(15)
            make.centerX.equalTo(view)
        }
        usernameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(view)
        }
        qrCodeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(usernameLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(250)
        }
        emailStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(qrCodeButton.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view).inset(30)
        }
        passwordStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailStackView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view).inset(30)
        }
        notificationsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordStackView.snp.bottom).offset(50)
            make.leading.equalTo(view).offset(30)
        }
        logoutButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(notificationsLabel.snp.bottom).offset(50)
            make.centerX.equalTo(view)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(250)
        }
    }
    
    @objc func enableEditing() {
        emailTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
