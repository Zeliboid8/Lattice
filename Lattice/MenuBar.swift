//
//  MenuBar.swift
//  Lattice
//
//  Created by Eli Zhang on 1/3/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ChangeView?
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    var barGradient: CAGradientLayer!
    var horizontalBar: UIView!
    
    let imageNames = ["CalendarGray", "EventsGray", "HomeGray", "GroupsGray", "ProfileGray"]
    
    let cellReuseIdentifier = "menuCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        setupHorizontalBar()
        
        let defaultSelectedItemPath = IndexPath(item: 0, section: 2)
        collectionView.selectItem(at: defaultSelectedItemPath, animated: false, scrollPosition: .left)
        
        setupGradient()
        setupConstraints()
    }
    
    func setupHorizontalBar() {
        horizontalBar = UIView()
        horizontalBar.backgroundColor = UIColor(red: 0.03, green: 0.85, blue: 0.84, alpha: 1)
        addSubview(horizontalBar)
    }
    
    func setupGradient() {
        let colorCenter = UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1)
        let colorSides = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1)
        barGradient = CAGradientLayer()
        barGradient.anchorPoint = .zero
        barGradient.colors = [colorSides, colorCenter, colorSides]
        barGradient.locations = [0.0, 1.0]
        barGradient.frame = frame
        layer.insertSublayer(barGradient, at: 0)
    }
    
    func setupConstraints() {
        horizontalBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.centerX.equalTo(self) // Sets bar to center (home)
            make.width.equalTo(self).dividedBy(5)
            make.height.equalTo(3)
        }
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        horizontalBar.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.width.equalTo(self).dividedBy(5)
            make.height.equalTo(3)
            make.left.equalTo(CGFloat(indexPath.section) * frame.width / 5)
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { self.layoutIfNeeded() }, completion: nil)
        delegate?.changeView(indexPath: indexPath) // Tells view controller to change to different screen corresponding to index
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.section])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 5, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
