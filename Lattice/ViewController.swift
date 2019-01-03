//
//  ViewController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/16/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var scanTextButton: UIButton!
    var eventsButton: UIButton!
    var viewCalendarButton: UIButton!
    var createGroupButton: UIButton!
    var addFriendButton: UIButton!
    var settingsButton: UIButton!
    
    let HPAD: CGFloat = 20
    let VPAD: CGFloat = 40
    let buttonHeight: CGFloat = 90
    let cornerRadius: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage = UIImage(named: "Mountain Background.png") {
            let imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = backgroundImage
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
        } else {
            view.backgroundColor = .white
        }
        
        scanTextButton = UIButton()
        scanTextButton.setTitle("Scan Text", for: .normal)
        scanTextButton.setTitleColor(.white, for: .normal)
        scanTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        scanTextButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        // scanTextButton.backgroundColor = UIColor(red: 0.929, green: 0.718, blue: 0.259, alpha: 1)
        scanTextButton.layer.cornerRadius = cornerRadius
        scanTextButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchDown)
        scanTextButton.addTarget(self, action: #selector(buttonReleased(sender:)), for: .touchUpOutside)
        scanTextButton.addTarget(self, action: #selector(presentTextSelectionView(sender:)), for: .touchUpInside)
        view.addSubview(scanTextButton)
        
        eventsButton = UIButton()
        eventsButton.setTitle("Your Events", for: .normal)
        eventsButton.setTitleColor(.white, for: .normal)
        eventsButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        eventsButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        // eventsButton.backgroundColor = UIColor(red: 0.929, green: 0.498, blue: 0.373, alpha: 1)
        eventsButton.layer.cornerRadius = cornerRadius
        eventsButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchDown)
        eventsButton.addTarget(self, action: #selector(buttonReleased(sender:)), for: .touchUpOutside)
        eventsButton.addTarget(self, action: #selector(presentNewEventView(sender:)), for: .touchUpInside)
        view.addSubview(eventsButton)
        
        viewCalendarButton = UIButton()
        viewCalendarButton.setTitle("Your Calendar", for: .normal)
        viewCalendarButton.setTitleColor(.white, for: .normal)
        viewCalendarButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        viewCalendarButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        // viewCalendarButton.backgroundColor = UIColor(red: 0.937, green: 0.486, blue: 0.714, alpha: 1)
        viewCalendarButton.layer.cornerRadius = cornerRadius
        viewCalendarButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchDown)
        viewCalendarButton.addTarget(self, action: #selector(buttonReleased(sender:)), for: .touchUpOutside)
        viewCalendarButton.addTarget(self, action: #selector(presentCalendarView(sender:)), for: .touchUpInside)
        view.addSubview(viewCalendarButton)
        
        createGroupButton = UIButton()
        createGroupButton.setTitle("Create a Group", for: .normal)
        createGroupButton.setTitleColor(.white, for: .normal)
        createGroupButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        createGroupButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        // createGroupButton.backgroundColor = UIColor(red: 0.243, green: 0.663, blue: 0.929, alpha: 1)
        createGroupButton.layer.cornerRadius = cornerRadius
        createGroupButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchDown)
        createGroupButton.addTarget(self, action: #selector(buttonReleased(sender:)), for: .touchUpOutside)
        createGroupButton.addTarget(self, action: #selector(presentGroupView(sender:)), for: .touchUpInside)
        view.addSubview(createGroupButton)
        
        addFriendButton = UIButton()
        addFriendButton.setTitle("Add a Friend", for: .normal)
        addFriendButton.setTitleColor(.white, for: .normal)
        addFriendButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        addFriendButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        // addFriendButton.backgroundColor = UIColor(red: 0.624, green: 0.541, blue: 0.914, alpha: 1)
        addFriendButton.layer.cornerRadius = cornerRadius
        addFriendButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchDown)
        addFriendButton.addTarget(self, action: #selector(buttonReleased(sender:)), for: .touchUpOutside)
        addFriendButton.addTarget(self, action: #selector(presentCodeScannerView(sender:)), for: .touchUpInside)
        view.addSubview(addFriendButton)
        
        settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "Gear"), for: .normal)
        settingsButton.addTarget(self, action: #selector(presentProfileView(sender:)), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        setUpConstraints()
    }
    
    @objc func setUpConstraints() {
        scanTextButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(2 * HPAD)
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalTo(view).inset(VPAD)
        }
        eventsButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(scanTextButton.snp.bottom).offset(HPAD)
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalTo(scanTextButton)
        }
        viewCalendarButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(eventsButton.snp.bottom).offset(HPAD)
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalTo(eventsButton)
        }
        createGroupButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(viewCalendarButton.snp.bottom).offset(HPAD)
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalTo(viewCalendarButton)
        }
        addFriendButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(createGroupButton.snp.bottom).offset(HPAD)
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalTo(createGroupButton)
        }
        settingsButton.snp.makeConstraints{ (make) -> Void in
            make.trailing.equalTo(view).offset(-HPAD)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-HPAD)
        }
    }
    
    @objc func buttonPressed(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.darker(by: 10)
    }
    
    @objc func buttonReleased(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 10)
    }
    
    @objc func presentTextSelectionView(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 10)
        let textSelectionView = TextSelectionController()
        present(textSelectionView, animated: true, completion: nil)
    }
    
    @objc func presentCodeScannerView(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 10)
        let codeScannerView = CodeScannerController()
        present(codeScannerView, animated: true, completion: nil)
    }
    
    @objc func presentNewEventView(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 10)
        let newEventView = EventCreationController()
        newEventView.modalPresentationStyle = .overCurrentContext
        present(newEventView, animated: true, completion: nil)
    }
    
    @objc func presentCalendarView(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 10)
        let calendarView = CalendarController()
        calendarView.modalPresentationStyle = .overCurrentContext
        present(calendarView, animated: true, completion: nil)
    }
    
    @objc func presentGroupView(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 10)
        let groupView = GroupViewController()
        present(groupView, animated: true, completion: nil)
    }
    
    @objc func presentProfileView(sender: UIButton) {
        let profileView = ProfileController()
        profileView.modalPresentationStyle = .overCurrentContext
        present(profileView, animated: true, completion: nil)
    }
}

// Color darkening extension provided by user "Stephen" here:  https://stackoverflow.com/questions/38435308/get-lighter-and-darker-color-variations-for-a-given-uicolor
extension UIColor {
    func lighter(by percentage: CGFloat) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }}
