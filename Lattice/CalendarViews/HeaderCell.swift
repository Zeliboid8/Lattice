//
//  HeaderCell.swift
//  Lattice
//
//  Created by Eli Zhang on 1/3/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class HeaderCell: UICollectionViewCell {
    var dayLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dayLabel = UILabel()
        contentView.addSubview(dayLabel)
    }
    
    override func updateConstraints() {
        dayLabel.snp.makeConstraints{ (make) -> Void in
            make.center.equalTo(contentView)
        }
        super.updateConstraints()
    }
    
    func configure(day: String) {
        dayLabel.text = day
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
