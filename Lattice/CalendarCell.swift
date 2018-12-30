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

class CalendarCell: JTAppleCell {
    var dateLabel: UILabel!
    var selectedView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.937, green: 0.486, blue: 0.714, alpha: 1)
        dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        
        selectedView = UIView()
        selectedView.backgroundColor = .white
        selectedView.layer.cornerRadius = 20
        selectedView.layer.opacity = 0.3
        selectedView.isHidden = true
        contentView.addSubview(selectedView)
    }
    
    override func updateConstraints() {
        dateLabel.snp.makeConstraints{ (make) -> Void in
            make.center.equalTo(contentView)
        }
        selectedView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(contentView)
            make.height.width.equalTo(40)
        }
        super.updateConstraints()
    }
    
    func configure(text: String) {
        dateLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
