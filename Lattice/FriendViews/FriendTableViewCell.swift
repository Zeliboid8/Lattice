//
//  FriendTableViewCell.swift
//  Lattice
//
//  Created by Eli Zhang on 1/25/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class FriendTableViewCell: UITableViewCell {
    
    var groupPhoto: UIImageView!
    var labelStackView: UIStackView!
    var nameLabel: UILabel!
    var memberLabel: UILabel!
    
    let photoHeight: CGFloat = 50
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .clear
        
        groupPhoto = UIImageView()
        groupPhoto.layer.masksToBounds = false
        groupPhoto.layer.cornerRadius = photoHeight / 2
        groupPhoto.clipsToBounds = true
        groupPhoto.contentMode = .scaleAspectFit
        contentView.addSubview(groupPhoto)
        
        nameLabel = UILabel()
        nameLabel.textColor = Colors.labelColor
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 25)
        
        memberLabel = UILabel()
        memberLabel.textColor = Colors.labelColor
        memberLabel.font = UIFont(name: "Nunito-Regular", size: 15)
        
        labelStackView = UIStackView()
        labelStackView.distribution = .fillProportionally
        labelStackView.axis = .vertical
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(memberLabel)
        contentView.addSubview(labelStackView)
    }
    
    override func updateConstraints() {
        groupPhoto.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
            make.height.width.equalTo(photoHeight)
        }
        labelStackView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.equalTo(contentView).inset(10).priority(999)
            make.leading.equalTo(groupPhoto.snp.trailing).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWithGroup(group: Group, photoName: String) {
        groupPhoto.image = UIImage(named: photoName)
        nameLabel.text = group.groupName
        if (group.hasName) {
            memberLabel.text = group.groupMembersString
        }
    }
    
    func configureWithUser(name: String) {
        nameLabel.text = name
    }
}
