//
//  EventCell.swift
//  Lattice
//
//  Created by Eli Zhang on 1/9/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class EventCell: UITableViewCell {
    
    var verticalBar: UIView!
    var eventTitle: UILabel!
    var eventTime: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        verticalBar = UIView()
        let randomColor: UIColor
        let randomIndex = Int.random(in: 0...3)
        switch(randomIndex) {
        case 0: randomColor = Colors.blue
        case 1: randomColor = Colors.red
        case 2: randomColor = Colors.yellow
        case 3: randomColor = Colors.purple
        default: randomColor = Colors.blue
        }
        
        verticalBar.backgroundColor = randomColor
        contentView.addSubview(verticalBar)
        
        eventTitle = UILabel()
        eventTitle.textColor = Colors.labelColor
        eventTitle.font = UIFont(name: "Nunito-Semibold", size: 20)
        contentView.addSubview(eventTitle)
        
        eventTime = UILabel()
        eventTime.textColor = Colors.labelColor
        eventTime.font = UIFont(name: "Nunito-Light", size: 18)
        contentView.addSubview(eventTime)
    }
    
    override func updateConstraints() {
        verticalBar.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView).offset(20)
            make.width.equalTo(5)
            make.top.bottom.equalTo(contentView)
        }
        eventTitle.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(verticalBar.snp.trailing).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
            make.top.equalTo(contentView).offset(15)
            make.height.equalTo(20)
        }
        eventTime.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(verticalBar.snp.trailing).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
            make.top.equalTo(eventTitle.snp.bottom).offset(20)
            make.bottom.equalTo(contentView).offset(-10)
        }
        super.updateConstraints()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let viewColor = verticalBar.backgroundColor
        super.setHighlighted(false, animated: animated)
        if highlighted {
            verticalBar.backgroundColor = .clear
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.verticalBar.backgroundColor = viewColor
            })
        }
        super.setHighlighted(highlighted, animated: animated)
        verticalBar.backgroundColor = viewColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let viewColor = verticalBar.backgroundColor
        super.setSelected(selected, animated: animated)
        verticalBar.backgroundColor = viewColor
    }
    
    func configure(eventTitle: String, eventTime: String) {
        self.eventTitle.text = eventTitle
        self.eventTime.text = eventTime
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
