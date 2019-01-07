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
    var labelStackView: UIStackView!
    var nameLabel: UILabel!
    var memberLabel: UILabel!
    
    let photoHeight: CGFloat = 50
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .clear
        
        groupPhoto = UIImageView()
        groupPhoto.image = UIImage(named: "ProfilePhoto")
        groupPhoto.layer.masksToBounds = false
        groupPhoto.layer.cornerRadius = photoHeight / 2
        groupPhoto.image = UIImage(named: "ProfilePhoto")
        groupPhoto.clipsToBounds = true
        groupPhoto.contentMode = .scaleAspectFit
        contentView.addSubview(groupPhoto)
        
        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 25)
        
        memberLabel = UILabel()
        memberLabel.textColor = .white
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
            make.top.bottom.equalTo(contentView).inset(20)
            make.leading.equalTo(groupPhoto.snp.trailing).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWithGroup(group: Group) {
        nameLabel.text = group.groupName
        if (group.hasName) {
            memberLabel.text = group.groupMembersString
        }
    }
    
    func configureWithUser(name: String) {
        nameLabel.text = name
    }
}

class AddMemberCell: GroupTableViewCell {
    
    var addButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        groupPhoto.isHidden = true
        
        addButton = UIButton()
        addButton.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.38, alpha: 1)
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 30)
        addButton.titleLabel?.textAlignment = .center
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.cornerRadius = photoHeight / 2
        addButton.isUserInteractionEnabled = false
        contentView.addSubview(addButton)
        
        nameLabel.text = "Add group member"
    }
    
    override func updateConstraints() {
        addButton.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
            make.height.width.equalTo(photoHeight)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
