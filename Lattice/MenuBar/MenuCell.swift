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
    let barColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = barColor
        imageView = UIImageView()
        imageView.tintColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
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
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
            backgroundColor = isHighlighted ? UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 0.7) : barColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
            backgroundColor = isSelected ? UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 0.7) : barColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
