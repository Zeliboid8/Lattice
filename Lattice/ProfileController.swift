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

    var nameTextField: UITextField!
    var netIDLabel: UILabel!
    var imageView: UIImageView!
    var yearTextField: UITextField!
    var majorTextField: UITextField!
    var bio: UITextView!
    var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        view.insertSubview(blurEffectView, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: view.frame.height / 3, width: view.frame.width, height: view.frame.height * 2 / 3), cornerRadius: 0).cgPath
        layer.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor
        view.layer.addSublayer(layer)
        
        imageView = UIImageView()
        view.addSubview(imageView)
        
        nameTextField = UITextField()
        nameTextField.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        nameTextField.isUserInteractionEnabled = false
        nameTextField.placeholder = "Name"
        nameTextField.text = "Joe Shmoe"
        nameTextField.textAlignment = .center
        view.addSubview(nameTextField)
        
        bio = UITextView()
        bio.backgroundColor = .clear
        bio.font = UIFont.systemFont(ofSize: 18, weight: .light)
        bio.textColor = .black
        bio.text = "squidward"
        view.addSubview(bio)
        
        signOutButton = UIButton()
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.setTitleColor(.black, for: .normal)
        signOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        view.addSubview(signOutButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEditing))
        
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(view).offset(-1 * view.frame.height / 6)
            make.centerX.equalTo(view)
            make.height.width.equalTo(100)
        }
        nameTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        bio.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.bottom.equalTo(signOutButton.snp.top).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        signOutButton.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(view).offset(20)
        }
    }
    
    @objc func signOut() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func enableEditing() {
        nameTextField.isUserInteractionEnabled = true
        netIDLabel.isUserInteractionEnabled = true
        yearTextField.isUserInteractionEnabled = true
        majorTextField.isUserInteractionEnabled = true
        bio.isEditable = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
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

}
