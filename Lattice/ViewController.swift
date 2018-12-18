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
        view.backgroundColor = .white
        
        scanTextButton = UIButton()
        scanTextButton.setTitle("Scan Text", for: .normal)
        scanTextButton.setTitleColor(.white, for: .normal)
        scanTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        scanTextButton.backgroundColor = UIColor(red: 0.929, green: 0.718, blue: 0.259, alpha: 1)
        scanTextButton.layer.cornerRadius = cornerRadius
        scanTextButton.addTarget(self, action: #selector(presentModalView), for: .touchUpInside)
        view.addSubview(scanTextButton)
        
        eventsButton = UIButton()
        eventsButton.setTitle("Your Events", for: .normal)
        eventsButton.setTitleColor(.white, for: .normal)
        eventsButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        eventsButton.backgroundColor = UIColor(red: 0.929, green: 0.498, blue: 0.373, alpha: 1)
        eventsButton.layer.cornerRadius = cornerRadius
        view.addSubview(eventsButton)
        
        viewCalendarButton = UIButton()
        viewCalendarButton.setTitle("Your Calendar", for: .normal)
        viewCalendarButton.setTitleColor(.white, for: .normal)
        viewCalendarButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        viewCalendarButton.backgroundColor = UIColor(red: 0.937, green: 0.486, blue: 0.714, alpha: 1)
        viewCalendarButton.layer.cornerRadius = cornerRadius
        view.addSubview(viewCalendarButton)
        
        createGroupButton = UIButton()
        createGroupButton.setTitle("Create Group", for: .normal)
        createGroupButton.setTitleColor(.white, for: .normal)
        createGroupButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        createGroupButton.backgroundColor = UIColor(red: 0.243, green: 0.663, blue: 0.929, alpha: 1)
        createGroupButton.layer.cornerRadius = cornerRadius
        view.addSubview(createGroupButton)
        
        addFriendButton = UIButton()
        addFriendButton.setTitle("Add Friend", for: .normal)
        addFriendButton.setTitleColor(.white, for: .normal)
        addFriendButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        addFriendButton.backgroundColor = UIColor(red: 0.624, green: 0.541, blue: 0.914, alpha: 1)
        addFriendButton.layer.cornerRadius = cornerRadius
        view.addSubview(addFriendButton)
        
        settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "Gear"), for: .normal)
        view.addSubview(settingsButton)
        
        setUpConstraints()
    }
    
    @objc func setUpConstraints() {
        scanTextButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(HPAD)
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
    
    @objc func presentModalView() {
        let modalView = TextSelectionViewController()
        present(modalView, animated: true, completion: nil)
    }
}

