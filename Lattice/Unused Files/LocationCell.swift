//
//  LocationCell.swift
//  Lattice
//
//  Created by Eli Zhang on 12/27/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class LocationCell: UITableViewCell {

    var locationLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        locationLabel = UILabel()
        contentView.addSubview(locationLabel)
    }
    
    override func updateConstraints() {
        locationLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(location: String) {
        locationLabel.text = location
    }
}
