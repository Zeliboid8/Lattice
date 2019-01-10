//
//  CalendarCell.swift
//  Lattice
//
//  Created by Eli Zhang on 12/19/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

enum Availability {
    case busy
    case some
    case free
}

class CalendarCell: JTAppleCell {
    var dateLabel: UILabel!
    var eventIndicatorView = UIView()
    var selectedView: UIView!
    
    let eventIndicatorSize: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        
        eventIndicatorView = UIView()
        eventIndicatorView.layer.cornerRadius = eventIndicatorSize / 2
        contentView.addSubview(eventIndicatorView)
        
        selectedView = UIView()
        selectedView.backgroundColor = .white
        selectedView.layer.cornerRadius = 5
        selectedView.layer.opacity = 0.3
        selectedView.isHidden = true
        contentView.addSubview(selectedView)
    }
    
    override func updateConstraints() {
        dateLabel.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-2)
        }
        eventIndicatorView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dateLabel.snp.bottom).offset(3)
            make.centerX.equalTo(contentView)
            make.height.width.equalTo(eventIndicatorSize)
        }
        selectedView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(contentView)
            make.height.width.equalTo(contentView.snp.height)
        }
        super.updateConstraints()
    }
    
    func configure(text: String, color: UIColor) {
        dateLabel.text = text
        eventIndicatorView.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
