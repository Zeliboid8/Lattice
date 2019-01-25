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

    var radialGradient: RadialGradientView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var eventNameLabel: UILabel!
    var eventNameTextField: UITextField!
    var startingTimeLabel: UILabel!
    var startingTimeTextField: UITextField!
    var endingTimeLabel: UILabel!
    var endingTimeTextField: UITextField!
    var startingDatePicker: UIDatePicker!
    var endingDatePicker: UIDatePicker!
    var locationLabel: UILabel!
    var locationTextField: UITextField!
    var notificationsLabel: UILabel!
    var notificationsDropDown: DropDownButton!
    var notificationsPreference: String = "In the morning"
    var privateLabel: UILabel!
    var privateSwitch: UISwitch!
    var submitButton: UIButton!
    
    let dateFormatter = DateFormatter()
    let submitButtonHeight: CGFloat = 50
    let vOffset: CGFloat = 30
    let hOffset: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "BackArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.imageView?.tintColor = Colors.labelColor
        backButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        view.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = "New Event"
        titleLabel.textColor = Colors.labelColor
        titleLabel.font = UIFont(name: "Nunito-Semibold", size: 40)
        view.addSubview(titleLabel)
        
        eventNameLabel = UILabel()
        eventNameLabel.text = "NAME"
        eventNameLabel.textColor = Colors.labelColor
        eventNameLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        view.addSubview(eventNameLabel)
        
        eventNameTextField = UITextField()
        eventNameTextField.attributedPlaceholder = NSAttributedString(string: "Event name", attributes: [NSAttributedString.Key.foregroundColor: Colors.grayLabelColor])
        eventNameTextField.textColor = Colors.labelColor
        eventNameTextField.font = UIFont(name: "Nunito-Regular", size: 18)
        view.addSubview(eventNameTextField)
        
        startingTimeLabel = UILabel()
        startingTimeLabel.text = "STARTS AT"
        startingTimeLabel.textColor = Colors.labelColor
        startingTimeLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        view.addSubview(startingTimeLabel)
        
        startingDatePicker = UIDatePicker()
        startingDatePicker.datePickerMode = .dateAndTime
        startingDatePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        startingTimeTextField = UITextField()
        startingTimeTextField.attributedPlaceholder = NSAttributedString(string: "Starting time", attributes: [NSAttributedString.Key.foregroundColor: Colors.grayLabelColor])
        startingTimeTextField.textColor = Colors.labelColor
        startingTimeTextField.inputView = startingDatePicker
        startingTimeTextField.font = UIFont(name: "Nunito-Semibold", size: 18)
        view.addSubview(startingTimeTextField)
        
        endingTimeLabel = UILabel()
        endingTimeLabel.text = "ENDS AT"
        endingTimeLabel.textColor = Colors.labelColor
        endingTimeLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        view.addSubview(endingTimeLabel)
        
        endingDatePicker = UIDatePicker()
        endingDatePicker.datePickerMode = .dateAndTime
        endingDatePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        endingTimeTextField = UITextField()
        endingTimeTextField.attributedPlaceholder = NSAttributedString(string: "Ending time", attributes: [NSAttributedString.Key.foregroundColor: Colors.grayLabelColor])
        endingTimeTextField.textColor = Colors.labelColor
        endingTimeTextField.inputView = endingDatePicker
        endingTimeTextField.font = UIFont(name: "Nunito-Regular", size: 18)
        view.addSubview(endingTimeTextField)
        
        locationLabel = UILabel()
        locationLabel.text = "LOCATION"
        locationLabel.textColor = Colors.labelColor
        locationLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        view.addSubview(locationLabel)
        
        locationTextField = UITextField()
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Event location", attributes: [NSAttributedString.Key.foregroundColor: Colors.grayLabelColor])
        locationTextField.textColor = Colors.labelColor
        locationTextField.font = UIFont(name: "Nunito-Regular", size: 18)
        view.addSubview(locationTextField)
        
        notificationsLabel = UILabel()
        notificationsLabel.text = "NOTIFICATIONS"
        notificationsLabel.textColor = Colors.labelColor
        notificationsLabel.textAlignment = .left
        notificationsLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        view.addSubview(notificationsLabel)
        
        notificationsDropDown = DropDownButton()
        notificationsDropDown.setTitle(notificationsPreference, for: .normal)
        notificationsDropDown.dropView.dropDownOptions = ["In the morning", "Never", "10 min before", "20 min before", "1 hour before"]
        view.addSubview(notificationsDropDown)
        
        privateLabel = UILabel()
        privateLabel.text = "PRIVATE"
        privateLabel.textColor = Colors.labelColor
        privateLabel.textAlignment = .left
        privateLabel.font = UIFont(name: "Nunito-Semibold", size: 18)
        view.addSubview(privateLabel)
        
        privateSwitch = UISwitch()
        view.addSubview(privateSwitch)
        
        submitButton = UIButton()
        submitButton.setTitle("Create event", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 25)
        submitButton.backgroundColor = Colors.red
        submitButton.layer.cornerRadius = submitButtonHeight / 2
        submitButton.layer.shadowColor = Colors.shadowColor
        submitButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        submitButton.layer.shadowOpacity = 0.8
        submitButton.layer.masksToBounds = false
        submitButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(submitButton)
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
    
        setupConstraints()
    }

    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        backButton.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.height.width.equalTo(30)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        submitButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-vOffset)
            make.leading.trailing.equalTo(view).inset(hOffset)
            make.height.equalTo(submitButtonHeight)
        }
        eventNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(vOffset)
        }
        eventNameTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(locationLabel.snp.trailing).offset(20)
            make.trailing.equalTo(view).offset(-hOffset)
            make.centerY.equalTo(eventNameLabel)
        }
        startingTimeLabel.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(vOffset)
            make.top.equalTo(eventNameLabel.snp.bottom).offset(hOffset)
        }
        startingTimeTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(locationLabel.snp.trailing).offset(20)
            make.trailing.equalTo(view).offset(-hOffset)
            make.centerY.equalTo(startingTimeLabel)
        }
        endingTimeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(startingTimeLabel.snp.bottom).offset(hOffset)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(vOffset)
        }
        endingTimeTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(locationLabel.snp.trailing).offset(20)
            make.trailing.equalTo(view).offset(-hOffset)
            make.centerY.equalTo(endingTimeLabel)
        }
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(endingTimeLabel.snp.bottom).offset(hOffset)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(vOffset)
            make.width.equalTo(100)
        }
        locationTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(locationLabel.snp.trailing).offset(20)
            make.trailing.equalTo(view).offset(-hOffset)
            make.centerY.equalTo(locationLabel)
        }
        notificationsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(locationLabel.snp.bottom).offset(hOffset)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(vOffset)
            make.width.equalTo(140)
        }
        notificationsDropDown.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(notificationsLabel)
            make.trailing.equalTo(view).offset(-10)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        privateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(notificationsLabel.snp.bottom).offset(hOffset)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(vOffset)
        }
        privateSwitch.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(privateLabel)
            make.centerX.equalTo(notificationsDropDown)
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        dateFormatter.dateFormat = "hh:mm a (E)"
        if datePicker == startingDatePicker {
            startingTimeTextField.text = dateFormatter.string(from: datePicker.date)
        } else {
            endingTimeTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
