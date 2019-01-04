//
//  EventCreationController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/26/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class EventCreationController: UIViewController {

    var backButton: UIButton!
    var stackView: UIStackView!
    var titleLabel: UILabel!
    var eventNameLabel: UILabel!
    var eventNameTextField: UITextField!
    var dateLabel: UILabel!
    var dateTextField: UITextField!
    var	datePicker: UIDatePicker!
    var locationLabel: UILabel!
    var locationTextField: UITextField!
    var submitButton: UIButton!
    
    let dateFormatter = DateFormatter()
    let buttonOffset: CGFloat = 8
    let vOffset: CGFloat = 30
    let hOffset: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, 	selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height + 60) // Accounts for difference between date picker and keyboard heights
        view.insertSubview(blurEffectView, at: 0)
        view.backgroundColor = .clear
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "BackArrowWhite"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissModalView), for: .touchUpInside)
        view.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = "Create an Event"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        eventNameLabel = UILabel()
        eventNameLabel.text = "Name:"
        eventNameLabel.textColor = .white
        eventNameLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
            
        eventNameTextField = UITextField()
        eventNameTextField.attributedPlaceholder = NSAttributedString(string: "Event name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)])
        eventNameTextField.textColor = .white
        eventNameTextField.font = UIFont.systemFont(ofSize: 25, weight: .light)
        view.addSubview(eventNameTextField)
        
        dateLabel = UILabel()
        dateLabel.text = "Date:"
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField = UITextField()
        dateTextField.attributedPlaceholder = NSAttributedString(string: "Event date", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)])
        dateTextField.textColor = .white
        dateTextField.inputView = datePicker
        dateTextField.font = UIFont.systemFont(ofSize: 25, weight: .light)
        view.addSubview(dateTextField)
        
        locationLabel = UILabel()
        locationLabel.text = "Location:"
        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        locationTextField = UITextField()
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Event location", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)])
        locationTextField.textColor = .white
        locationTextField.font = UIFont.systemFont(ofSize: 25, weight: .light)
        view.addSubview(locationTextField)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 25
        stackView.addArrangedSubview(eventNameLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(locationLabel)
        view.addSubview(stackView)
        
        submitButton = UIButton()
        submitButton.layer.cornerRadius = 10
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.borderWidth = 1
        submitButton.backgroundColor = .clear
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        submitButton.setTitle("Create Event", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(dismissModalView), for: .touchUpInside)
        view.addSubview(submitButton)
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        view.addGestureRecognizer(tapToDismiss)
    
        setupConstraints()
    }

    func setupConstraints() {
        backButton.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(buttonOffset)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(vOffset)
            make.height.width.equalTo(30)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(hOffset)
            make.trailing.equalTo(view).offset(-hOffset)
            make.height.equalTo(70)
        }
        submitButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-vOffset)
            make.leading.trailing.equalTo(view).inset(hOffset)
            make.height.equalTo(80)
        }
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(vOffset)
            make.leading.equalTo(view).offset(hOffset)
//            make.bottom.equalTo(submitButton.snp.top).offset(-vOffset)
            make.width.equalTo(110)
        }
        eventNameTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(eventNameLabel.snp.trailing).offset(hOffset)
            make.trailing.equalTo(view).offset(-hOffset)
            make.centerY.equalTo(eventNameLabel)
        }
        dateTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(dateLabel.snp.trailing).offset(hOffset)
            make.trailing.equalTo(view).offset(-hOffset)
            make.centerY.equalTo(dateLabel)
        }
        locationTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(locationLabel.snp.trailing).offset(hOffset)
            make.trailing.equalTo(view).offset(-hOffset)
            make.centerY.equalTo(locationLabel)
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
}
