//
//  HeaderEventCell.swift
//  Lattice
//
//  Created by Eli Zhang on 1/9/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class HeaderEventCell: UITableViewCell {

    var dayLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.highlightedCell
        
        dayLabel = UILabel()
        dayLabel.textColor = Colors.labelColor
        dayLabel.font = UIFont(name: "Nunito-Light", size: 20)
        contentView.addSubview(dayLabel)
    }
    
    override func updateConstraints() {
        dayLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(contentView).inset(30)
            make.centerY.equalTo(contentView)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
