//
//  GroupTableViewCell.swift
//  Lattice
//
//  Created by Eli Zhang on 12/31/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class GroupTableViewCell: UITableViewCell {

    var groupPhoto: UIImageView!
    var memberLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        groupPhoto = UIImageView()
        groupPhoto.image = UIImage(named: "Donut")
        contentView.addSubview(groupPhoto)
        
        memberLabel = UILabel()
        memberLabel.textColor = .white
        memberLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        contentView.addSubview(memberLabel)
        
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = UIColor(red: 0.84, green: 0.25, blue: 0.52, alpha: 1.0)
    }
    
    override func updateConstraints() {
        groupPhoto.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(30)
            make.height.width.equalTo(50)
        }
        memberLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(groupPhoto.snp.trailing).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(members: String) {
        memberLabel.text = members
    }
}
