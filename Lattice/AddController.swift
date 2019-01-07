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
        
        calendarButton = AddButton()
        calendarButton.configure(image: UIImage(named: "Calendar")!, title: "Calendar")
        
        eventButton = AddButton()
        eventButton.configure(image: UIImage(named: "Cake")!, title: "Event")
        
        topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.spacing = 30
        topStackView.distribution = .fillEqually
        topStackView.addArrangedSubview(calendarButton)
        topStackView.addArrangedSubview(eventButton)
        
        groupButton = AddButton()
        groupButton.configure(image: UIImage(named: "Groups")!, title: "Group")
        
        friendButton = AddButton()
        friendButton.configure(image: UIImage(named: "Profile")!, title: "Friend")
        
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
        verticalStackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(30)
        }
    }
}

class AddButton: UIButton {
    
    let labelColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .purple
        
        setTitleColor(labelColor, for: .normal)
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 5, height: 7)
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
    }
    
    func alignImageAndTitleVertically(padding: CGFloat) {
        let imageSize = imageView!.frame.size
        let titleSize = titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
    func configure(image: UIImage, title: String) {
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "Nunito-Bold", size: 50)
        imageView?.tintColor = labelColor
        alignImageAndTitleVertically(padding: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
