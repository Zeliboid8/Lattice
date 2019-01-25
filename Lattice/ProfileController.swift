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

    var radialGradient: RadialGradientView!
    var profilePhoto: UIImageView!
    var nameLabel: UILabel!
    var usernameLabel: UILabel!
    var qrCodeButton: CenteredButton!
    var notificationsLabel: UILabel!
    var notificationsDropDown: DropDownButton!
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var logoutButton: UIButton!
    
    var notificationsPreference: String = "Every morning"
    
    let photoHeight: CGFloat = 100
    let buttonHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        profilePhoto = UIImageView()
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = photoHeight / 2
        profilePhoto.image = UIImage(named: "ProfilePhoto")
        profilePhoto.clipsToBounds = true
        profilePhoto.contentMode = .scaleAspectFit
        
        nameLabel = UILabel()
        nameLabel.text = "Eli Zhang"
        nameLabel.textColor = Colors.labelColor
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 30)
        
        usernameLabel = UILabel()
        usernameLabel.text = "@elikzhang"
        usernameLabel.textColor = Colors.labelColor
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        
        qrCodeButton = CenteredButton()
        qrCodeButton.configure(image: UIImage(named: "QRCode")!, title: "My QR Code")
        qrCodeButton.backgroundColor = Colors.blue
        qrCodeButton.setTitleColor(Colors.labelColor, for: .normal)
        qrCodeButton.layer.cornerRadius = buttonHeight / 2
        
        notificationsLabel = UILabel()
        notificationsLabel.text = "NOTIFICATIONS"
        notificationsLabel.textColor = Colors.labelColor
        notificationsLabel.textAlignment = .left
        notificationsLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        
        emailLabel = UILabel()
        emailLabel.text = "EMAIL"
        emailLabel.textColor = Colors.labelColor
        emailLabel.textAlignment = .left
        emailLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        
        emailTextField = UITextField()
        emailTextField.text = "elikzhang@gmail.com"
        emailTextField.placeholder = "Email"
        emailTextField.textColor = Colors.labelColor
        emailTextField.textAlignment = .right
        emailTextField.font = UIFont(name: "Nunito-Regular", size: 18)
        
        passwordLabel = UILabel()
        passwordLabel.text = "PASSWORD"
        passwordLabel.textColor = Colors.labelColor
        passwordLabel.textAlignment = .left
        passwordLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        
        passwordTextField = UITextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.text = "password123"
        passwordTextField.textColor = Colors.labelColor
        passwordTextField.placeholder = "Password"
        passwordTextField.textAlignment = .right
        passwordTextField.font = UIFont(name: "Nunito-Regular", size: 18)
        
        logoutButton = UIButton()
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(Colors.labelColor, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        logoutButton.backgroundColor = Colors.red
        logoutButton.layer.cornerRadius = buttonHeight / 2
        logoutButton.layer.shadowColor = Colors.shadowColor
        logoutButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        logoutButton.layer.shadowOpacity = 0.8
        logoutButton.layer.masksToBounds = false
        
        notificationsDropDown = DropDownButton()
        notificationsDropDown.setTitle(notificationsPreference, for: .normal)
        notificationsDropDown.dropView.dropDownOptions = ["Every morning", "Before events", "Never"]
        view.addSubview(notificationsDropDown)

        view.addSubview(profilePhoto)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(qrCodeButton)
        view.addSubview(notificationsLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(logoutButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
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
        notificationsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(qrCodeButton.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(30)
            make.width.equalTo(140)
        }
        notificationsDropDown.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(notificationsLabel)
            make.trailing.equalTo(view).offset(-10)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        emailLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(notificationsLabel.snp.bottom).offset(50)
            make.leading.equalTo(view).offset(30)
        }
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailLabel)
            make.leading.equalTo(emailLabel.snp.trailing).offset(30)
            make.trailing.equalTo(view).offset(-20)
        }
        passwordLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(30)
        }
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordLabel)
            make.leading.equalTo(passwordLabel.snp.trailing).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        logoutButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordLabel.snp.bottom).offset(50)
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
}

class CenteredButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .center
        layer.shadowColor = Colors.shadowColor
        layer.shadowOffset = CGSize(width: 5, height: 7)
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var imageFrame = (imageView?.frame)!
        var titleFrame = (titleLabel?.frame)!
        imageFrame.origin.y = bounds.midY - imageFrame.height / 2
        imageFrame.origin.x = bounds.midX + titleFrame.width / 2 - imageFrame.width / 2 + 10
        imageView?.frame = imageFrame
        
        titleFrame.origin.y = bounds.midY - titleFrame.height / 2
        titleFrame.origin.x = bounds.midX - titleFrame.width / 2 - imageFrame.height / 2 - 10
        titleLabel?.frame = titleFrame
    }
    
    func configure(image: UIImage, title: String) {
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        setTitle(title, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        imageView?.tintColor = Colors.labelColor
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        contentMode = .scaleAspectFit
        titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        titleLabel?.textAlignment = .center
    }
}
