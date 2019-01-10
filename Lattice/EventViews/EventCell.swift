//
//  EventCell.swift
//  Lattice
//
//  Created by Eli Zhang on 1/9/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    var verticalBar: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        verticalBar = UIView()
        contentView.addSubview(verticalBar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
