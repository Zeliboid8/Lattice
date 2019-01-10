//
//  TimeCell.swift
//  Lattice
//
//  Created by Eli Zhang on 1/10/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class TimeCell: UITableViewCell {
    var timeLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        timeLabel = UILabel()
        timeLabel.font = UIFont(name: "Nunito-Semibold", size: 15)
        timeLabel.textColor = Colors.labelColor
        contentView.addSubview(timeLabel)
    }
    
    override func updateConstraints() {
        timeLabel.snp.remakeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(contentView).inset(5)
            make.centerY.equalTo(contentView).offset(-contentView.frame.height / 4)
        }
        super.updateConstraints()
    }
    
    func configure(title: String) {
        timeLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
