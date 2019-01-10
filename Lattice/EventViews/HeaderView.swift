//
//  HeaderView.swift
//  Lattice
//
//  Created by Eli Zhang on 1/9/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class HeaderView: UITableViewHeaderFooterView  {

    var dayLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.headerColor
        
        dayLabel = UILabel()
        dayLabel.textColor = Colors.labelColor
        dayLabel.font = UIFont(name: "Nunito-Light", size: 15)
        contentView.addSubview(dayLabel)
    }
    
    override func updateConstraints() {
        dayLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(contentView).inset(30)
            make.centerY.equalTo(contentView)
        }
        super.updateConstraints()
    }
    
    func configure(dayName: String) {
        dayLabel.text = dayName.uppercased()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
