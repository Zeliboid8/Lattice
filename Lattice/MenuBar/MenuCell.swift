//
//  MenuCell.swift
//  Lattice
//
//  Created by Eli Zhang on 1/3/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class MenuCell: UICollectionViewCell {
    var imageView: UIImageView!
    let barColor = UIColor.clear
    let defaultTint = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    let highlightedColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = barColor
        imageView = UIImageView()
        imageView.tintColor = defaultTint
        contentView.addSubview(imageView)
    }
    
    override func updateConstraints() {
        imageView.snp.makeConstraints {(make) -> Void in
            make.center.equalTo(contentView)
            make.height.width.equalTo(contentView.frame.height - 35)
        }
        super.updateConstraints()
    }
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : defaultTint
            backgroundColor = isHighlighted ? highlightedColor : barColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : defaultTint
            backgroundColor = isSelected ? highlightedColor : barColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
