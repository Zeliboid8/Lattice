//
//  WeekAvailabilityController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/31/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class WeekAvailabilityController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let timeCellReuseIdentifier = "timeCell"
    let headerCellReuseIdentifier = "header"
    let dateFormatter = DateFormatter()
    let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let slotsPerHour: Int = 1
    let startingHour: Int = 11
    let endingHour: Int = 20
    var numTimeCells: Int {
        return (endingHour - startingHour + 1) * slotsPerHour
    }
    let headerCellHeight: CGFloat = 30
    var verticalSwipe: UIPanGestureRecognizer!
    var tap: UITapGestureRecognizer!
    var dailyTimes: UIStackView!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        dailyTimes = UIStackView()
        dailyTimes.axis = .vertical
        dailyTimes.distribution = .fillEqually
        for hour in startingHour...endingHour {
            for minute in 0..<slotsPerHour {
                let timeLabel = UILabel()
                timeLabel.text = "\(hour <= 12 ? hour : hour - 12):\(String(format: "%02d", 60 / slotsPerHour * minute)) \(hour <= 12 ? "am" : "pm")"
                dailyTimes.addArrangedSubview(timeLabel)
            }
        }
        view.addSubview(dailyTimes)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: timeCellReuseIdentifier)
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: headerCellReuseIdentifier)
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        
        verticalSwipe = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        verticalSwipe.delegate = self
        collectionView.addGestureRecognizer(verticalSwipe)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
        setupConstraints()
    }
    
    func setupConstraints() {
        dailyTimes.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50 - headerCellHeight)
            make.leading.equalTo(dailyTimes.snp.trailing).offset(10)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc func handlePan() {
        if verticalSwipe.state == UIGestureRecognizer.State.began {
            print("Swipe begins")   // Shouldn't do anything because it may be scrolling
        }
        else if verticalSwipe.state == UIGestureRecognizer.State.changed {
            if abs(verticalSwipe.velocity(in: collectionView).x) < 50 {
                if let indexPath = collectionView.indexPathForItem(at: verticalSwipe.location(in: collectionView)) {
                    print(indexPath)
                    if collectionView.cellForItem(at: indexPath)?.tag == 0 {
                        collectionView.cellForItem(at: indexPath)?.backgroundColor = .green
                        collectionView.cellForItem(at: indexPath)?.tag = 1
                    }
                    else {
                        collectionView.cellForItem(at: indexPath)?.backgroundColor = .white
                        collectionView.cellForItem(at: indexPath)?.tag = 0
                    }
                }
            }
        } else {
            if abs(verticalSwipe.velocity(in: collectionView).x) < 50 {
                if let indexPath = collectionView.indexPathForItem(at: verticalSwipe.location(in: collectionView)) {
                    print(indexPath)
                    if collectionView.cellForItem(at: indexPath)?.tag == 0 {
                        collectionView.cellForItem(at: indexPath)?.backgroundColor = .green
                        collectionView.cellForItem(at: indexPath)?.tag = 1
                    }
                    else {
                        collectionView.cellForItem(at: indexPath)?.backgroundColor = .white
                        collectionView.cellForItem(at: indexPath)?.tag = 0
                    }
                }
            }
        }
    }
    
    @objc func handleTap() {
        if let indexPath = collectionView.indexPathForItem(at: tap.location(in: collectionView)) {
            print(indexPath)
            if collectionView.cellForItem(at: indexPath)?.tag == 0 {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = .green
                collectionView.cellForItem(at: indexPath)?.tag = 1
            }
            else {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = .white
                collectionView.cellForItem(at: indexPath)?.tag = 0
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numTimeCells + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {    // Day name header
            return CGSize(width: collectionView.frame.width, height: headerCellHeight)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height - headerCellHeight - 0.01) / CGFloat(numTimeCells))   // Must subtract a small amount due to round-off problems
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellReuseIdentifier, for: indexPath) as! HeaderCell
            cell.configure(day: dayNames[indexPath.section])
            cell.setNeedsUpdateConstraints()
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellReuseIdentifier, for: indexPath)
            cell.backgroundColor = .white
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
    }
}
