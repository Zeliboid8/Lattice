//
//  WeekAvailabilityController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/31/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class BlockCalendarController: UIViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, DropDownData {
    
    var radialGradient: RadialGradientView!
    var verticalSwipe: UIPanGestureRecognizer!
    var tap: UITapGestureRecognizer!
    var backButton: UIButton!
    var blockCalendarLabel: UILabel!
    var separator: UIView!
    var fromLabel: UILabel!
    var fromDropDown: DropDownButton!
    var toLabel: UILabel!
    var toDropDown: DropDownButton!
    var dailyTimes: UITableView!
    var collectionView: UICollectionView!
    var cellStates: [[CellSelectedState]]!
    var addButton: UIButton!
    
    var selecting: Bool = true

    let timeLabelCellReuseIdentifier = "timeLabel"
    let timeCellReuseIdentifier = "timeCell"
    let headerCellReuseIdentifier = "header"
    let dateFormatter = DateFormatter()
    let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var slotsPerHour: Int = 2
    let minStartingHour: Int = 0
    var startingHour: Int = 9
    var fromTime: String {
        if startingHour == 0 { return "12:00 am"}
        return "\(startingHour <= 12 ? startingHour : startingHour - 12):00 \(startingHour <= 12 ? "am" : "pm")"
    }
    let maxEndingHour: Int = 24
    var endingHour: Int = 17
    var toTime: String {
        if endingHour == 0 { return "12:00 am"}
        return "\(endingHour <= 12 ? endingHour : endingHour - 12):00 \(endingHour <= 12 ? "am" : "pm")"
    }
    var numTimeCells: Int {
        return (endingHour - startingHour + 1) * slotsPerHour
    }
    let headerCellHeight: CGFloat = 30

    override func viewDidLoad() {
        view.backgroundColor = .black
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "BackArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.imageView?.tintColor = Colors.labelColor
        backButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        view.addSubview(backButton)
        
        blockCalendarLabel = UILabel()
        blockCalendarLabel.text = "Block times"
        blockCalendarLabel.textColor = Colors.labelColor
        blockCalendarLabel.font = UIFont(name: "Nunito-Regular", size: 30)
        view.addSubview(blockCalendarLabel)
        
        fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Colors.labelColor
        fromLabel.font = UIFont(name: "Nunito-Light", size: 18)
        view.addSubview(fromLabel)
        
        fromDropDown = DropDownButton()
        fromDropDown.setTitle(fromTime, for: .normal)
        fromDropDown.dropView.dropDownOptions = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm"]
        fromDropDown.delegate = self
        view.addSubview(fromDropDown)
        
        toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Colors.labelColor
        toLabel.font = UIFont(name: "Nunito-Light", size: 18)
        view.addSubview(toLabel)
        
        toDropDown = DropDownButton()
        toDropDown.setTitle(toTime, for: .normal)
        toDropDown.dropView.dropDownOptions = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm"]
        toDropDown.delegate = self
        view.addSubview(toDropDown)
        
        dailyTimes = UITableView()
        dailyTimes.delegate = self
        dailyTimes.dataSource = self
        dailyTimes.register(TimeCell.self, forCellReuseIdentifier: timeLabelCellReuseIdentifier)
        dailyTimes.isScrollEnabled = false
        dailyTimes.backgroundColor = .clear
        dailyTimes.isUserInteractionEnabled = false
        dailyTimes.separatorStyle = .none
        view.addSubview(dailyTimes)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: timeCellReuseIdentifier)
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: headerCellReuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        
        addButton = UIButton()
        addButton.backgroundColor = Colors.purple
        addButton.setImage(UIImage(named: "Check")?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        addButton.imageView?.tintColor = Colors.labelColor
        addButton.layer.cornerRadius = 40
        addButton.layer.shadowColor = Colors.shadowColor
        addButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        addButton.layer.shadowOpacity = 0.8
        addButton.layer.shadowRadius = 2
        addButton.layer.masksToBounds = false
        addButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        view.addSubview(addButton)
        
        verticalSwipe = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        verticalSwipe.delegate = self
        collectionView.addGestureRecognizer(verticalSwipe)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
        
        cellStates = [[CellSelectedState]]()
        for section in 0..<collectionView.numberOfSections {
            cellStates.append([CellSelectedState]())
            for _ in minStartingHour...(maxEndingHour * slotsPerHour) {
                cellStates[section].append(CellSelectedState(isSelected: false))
            }
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.height.width.equalTo(30)
        }
        blockCalendarLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(collectionView)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(30)
        }
        fromLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(blockCalendarLabel)
            make.top.equalTo(blockCalendarLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        fromDropDown.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(fromLabel.snp.trailing)
            make.top.equalTo(fromLabel)
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
        toLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(fromDropDown.snp.trailing)
            make.top.equalTo(fromLabel)
            make.height.equalTo(40)
        }
        toDropDown.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(toLabel.snp.trailing)
            make.top.equalTo(fromLabel)
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
        dailyTimes.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(collectionView).offset(headerCellHeight)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20 - MenuBarParameters.menuBarHeight)
            make.width.equalTo(80)
        }
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(fromLabel.snp.bottom).offset(10)
            make.leading.equalTo(dailyTimes.snp.trailing)
            make.trailing.equalTo(view).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20 - MenuBarParameters.menuBarHeight)
        }
        addButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(80)
            make.trailing.equalTo(view).offset(-35)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-45 - MenuBarParameters.menuBarHeight)
        }
    }
    
    func itemSelected(sender: DropDownButton, contents: String) {
        if sender == fromDropDown {
            if contents.prefix(2) == "12" {
                startingHour = contents.suffix(2) == "am" ? 0 : 12
                dailyTimes.reloadData()
                collectionView.reloadData()
                return
            }
            startingHour = Int(contents.components(separatedBy: ":").first!) ?? startingHour
            if contents.suffix(2) == "pm" {
                startingHour += 12
            }
        }
        else if sender == toDropDown {
            if contents.prefix(2) == "12" {
                endingHour = contents.suffix(2) == "am" ? 0 : 12
                dailyTimes.reloadData()
                collectionView.reloadData()
                return
            }
            endingHour = Int(contents.components(separatedBy: ":").first!) ?? endingHour
            if contents.suffix(2) == "pm" {
                endingHour += 12
            }
        }
        dailyTimes.reloadData()
        collectionView.reloadData()
    }
    
    @objc func handlePan() {
        if verticalSwipe.state == UIGestureRecognizer.State.began {
            if let indexPath = collectionView.indexPathForItem(at: verticalSwipe.location(in: collectionView)) {
                self.selecting = !self.cellStates[indexPath.section][indexPath.item].isSelected
            }
        }
        else if verticalSwipe.state == UIGestureRecognizer.State.changed {
            if abs(verticalSwipe.velocity(in: collectionView).x) < 100 {
                if let indexPath = collectionView.indexPathForItem(at: verticalSwipe.location(in: collectionView)) {
                    if indexPath.item == 0 {
                        return
                    }
                    let timeCell = collectionView.cellForItem(at: indexPath)
                    if selecting {// !cellStates[indexPath.section][indexPath.item].isSelected {
                        timeCell?.backgroundColor = Colors.highlightedCell
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.cellStates[indexPath.section][indexPath.item].isSelected = true
                        }
                    }
                    else {
                        timeCell?.backgroundColor = .clear
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.cellStates[indexPath.section][indexPath.item].isSelected = false
                        }
                    }
                }
            }
        } else {
            if abs(verticalSwipe.velocity(in: collectionView).x) < 100 {
                if let indexPath = collectionView.indexPathForItem(at: verticalSwipe.location(in: collectionView)) {
                    if indexPath.item == 0 {
                        return
                    }
                    let timeCell = collectionView.cellForItem(at: indexPath)
                    if selecting { // !cellStates[indexPath.section][indexPath.item].isSelected {
                        timeCell?.backgroundColor = Colors.highlightedCell
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.cellStates[indexPath.section][indexPath.item].isSelected = true
                        }
                    }
                    else {
                        timeCell?.backgroundColor = .clear
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.cellStates[indexPath.section][indexPath.item].isSelected = false
                        }
                    }
                }
            }
        }
    }
    
    @objc func handleTap() {
        if let indexPath = collectionView.indexPathForItem(at: tap.location(in: collectionView)) {
            if indexPath.item == 0 {
                return
            }
            let timeCell = collectionView.cellForItem(at: indexPath)
            if !cellStates[indexPath.section][indexPath.item].isSelected {
                timeCell?.backgroundColor = Colors.highlightedCell
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.cellStates[indexPath.section][indexPath.item].isSelected = true
                }
            }
            else {
                timeCell?.backgroundColor = .clear
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.cellStates[indexPath.section][indexPath.item].isSelected = false
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveData() {
        popView()
    }
}
extension BlockCalendarController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endingHour - startingHour + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dailyTimes.dequeueReusableCell(withIdentifier: timeLabelCellReuseIdentifier, for: indexPath) as! TimeCell
        let hour = startingHour + indexPath.row
        cell.configure(title: "\(hour == 0 ? 12 : hour <= 12 ? hour : hour - 12):00 \(hour < 12 ? "am" : "pm")")
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(tableView.numberOfRows(inSection: 0))
    }
}

extension BlockCalendarController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numTimeCells + 1     // Adding 1 for header cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {    // Day name header
            return CGSize(width: collectionView.frame.width, height: headerCellHeight)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height - headerCellHeight - 0.01) / CGFloat(numTimeCells))   // Must subtract a small amount due to round-off problems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let customCell = cell as! HeaderCell
            customCell.configure(day: dayNames[indexPath.section])
            customCell.backgroundColor = Colors.blue
            customCell.setNeedsUpdateConstraints()
            customCell.layer.borderColor = Colors.infoBox.cgColor
            customCell.layer.borderWidth = 1
        }
        else {
            if cellStates[indexPath.section][indexPath.item].isSelected {
                cell.backgroundColor = Colors.highlightedCell
            }
            else {
                cell.backgroundColor = .clear
            }
            cell.layer.borderColor = Colors.infoBox.cgColor
            cell.layer.borderWidth = 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellReuseIdentifier, for: indexPath) as! HeaderCell
            cell.configure(day: dayNames[indexPath.section])
            cell.backgroundColor = Colors.blue
            cell.setNeedsUpdateConstraints()
            cell.layer.borderColor = Colors.infoBox.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellReuseIdentifier, for: indexPath)
            if cellStates[indexPath.section][indexPath.item].isSelected {
                cell.backgroundColor = Colors.highlightedCell
            }
            else {
                cell.backgroundColor = .clear
            }
            cell.layer.borderColor = Colors.infoBox.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
    }
}

struct CellSelectedState {
    var isSelected: Bool // selection state
}

