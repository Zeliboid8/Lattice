//
//  AddController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/7/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class AddController: UIViewController {

    var radialGradient: RadialGradientView!
    var backButton: UIButton!
    var calendarButton: AddButton!
    var eventButton: AddButton!
    var groupButton: AddButton!
    var friendButton: AddButton!
    var topStackView: UIStackView!
    var bottomStackView: UIStackView!
    var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "DownArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.imageView?.tintColor = Colors.labelColor
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(backButton)
        
        calendarButton = AddButton()
        calendarButton.configure(image: UIImage(named: "Calendar")!, title: "Calendar")
        calendarButton.backgroundColor = Colors.red
        
        eventButton = AddButton()
        eventButton.configure(image: UIImage(named: "Clock")!, title: "Event")
        eventButton.backgroundColor = Colors.blue
        
        topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.spacing = 30
        topStackView.distribution = .fillEqually
        topStackView.addArrangedSubview(calendarButton)
        topStackView.addArrangedSubview(eventButton)
        
        groupButton = AddButton()
        groupButton.configure(image: UIImage(named: "Groups")!, title: "Group")
        groupButton.backgroundColor = Colors.purple
        
        friendButton = AddButton()
        friendButton.configure(image: UIImage(named: "Profile")!, title: "Friend")
        friendButton.backgroundColor = Colors.yellow
        
        bottomStackView = UIStackView()
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 30
        bottomStackView.distribution = .fillEqually
        bottomStackView.addArrangedSubview(groupButton)
        bottomStackView.addArrangedSubview(friendButton)
        
        verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 30
        verticalStackView.distribution = .fillEqually
        verticalStackView.addArrangedSubview(topStackView)
        verticalStackView.addArrangedSubview(bottomStackView)
        view.addSubview(verticalStackView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(30)
        }
        verticalStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

class AddButton: UIButton {

    let padding: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(Colors.labelColor, for: .normal)
        
        layer.cornerRadius = 10
        layer.shadowColor = Colors.shadowColor
        layer.shadowOffset = CGSize(width: 5, height: 7)
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let titleRect = self.titleRect(forContentRect: contentRect)
        
        return CGRect(x: contentRect.width/2.0 - rect.width/2.0,
                      y: (contentRect.height - titleRect.height)/2.0 - rect.height/2.0,
                      width: rect.width - 2 * padding, height: rect.width - 2 * padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var imageFrame = (imageView?.frame)!
        imageFrame.origin.y = bounds.midY - imageFrame.height / 2 - padding
        imageFrame.origin.x = bounds.midX - imageFrame.width / 2
        imageView?.frame = imageFrame
        
        var titleFrame: CGRect = (titleLabel?.frame)!
        titleFrame.size.width = frame.width
        titleFrame.size.height = 100
        
        titleFrame.origin.y = imageFrame.maxY - padding
        titleFrame.origin.x = bounds.origin.x
        titleLabel?.frame = titleFrame
    }
    
    func configure(image: UIImage, title: String) {
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "Nunito-Bold", size: 25)
        titleLabel?.textAlignment = .center
        imageView?.tintColor = Colors.labelColor
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
