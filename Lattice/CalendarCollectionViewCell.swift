//
//  CalendarCollectionViewCell.swift
//  Lattice
//
//  Created by Eli Zhang on 12/19/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

class CalendarCollectionViewCell: JTAppleCell {
    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        dateLabel = UILabel()
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
    }
    
    override func updateConstraints() {
        dateLabel.snp.makeConstraints{ (make) -> Void in
            make.center.equalTo(contentView)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
