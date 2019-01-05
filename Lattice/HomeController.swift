//
//  HomeController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/3/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

class HomeController: UIViewController {

    var menuBar: MenuBar!
    var radialGradient: RadialGradientView!
    var calendar: JTAppleCalendarView!
    var infoBox: UIView!
    var dayNames: UIStackView!
    var monthLabel: UILabel!
    var addButton: UIButton!
    
    let formatter = DateFormatter()
    let labelColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
    let dayTitles = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let calCellReuseIdentifier = "calCellReuseIdentifier"
    let menuBarHeight: CGFloat = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        menuBar = MenuBar()
        view.addSubview(menuBar)
        
        setupInfoBox()
        
        addButton = UIButton()
        addButton.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.38, alpha: 1)
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 50)
        addButton.titleLabel?.textAlignment = .center
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.cornerRadius = 40
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        addButton.layer.shadowOpacity = 0.8
        addButton.layer.shadowRadius = 2
        addButton.layer.masksToBounds = false
        view.addSubview(addButton)
        
        setupCalendar()
        setupConstraints()
    }
    
    func setupCalendar() {
        monthLabel = UILabel()
        monthLabel.textColor = labelColor
        monthLabel.font = UIFont(name: "Nunito-Regular", size: 40)
        view.addSubview(monthLabel)
        
        // Setting up day name labels
        dayNames = UIStackView()
        dayNames.distribution = .fillEqually
        for day in dayTitles {
            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.textAlignment = .center
            dayLabel.textColor = labelColor
            dayLabel.font = UIFont(name: "Nunito-Bold", size: 15)
            dayNames.addArrangedSubview(dayLabel)
        }
        view.addSubview(dayNames)
        
        calendar = JTAppleCalendarView(frame: .zero)
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        calendar.showsHorizontalScrollIndicator = false
        calendar.scrollDirection = .horizontal
        calendar.minimumInteritemSpacing = 0
        calendar.minimumLineSpacing = 0
        calendar.isPagingEnabled = true
        calendar.register(CalendarCell.self, forCellWithReuseIdentifier: calCellReuseIdentifier)
        calendar.selectDates([Date()])
        calendar.backgroundColor = .clear
        
        calendar.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "YYYY"
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
            
        }
        view.addSubview(calendar)
    }
    
    func setupInfoBox() {
        infoBox = UIView()
        infoBox.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.64)
        infoBox.layer.cornerRadius = 8
        
        
        view.addSubview(infoBox)
    }
    
    func setupConstraints() {
        menuBar.snp.makeConstraints { (make) -> Void in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(menuBarHeight)
        }
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        monthLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        dayNames.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(monthLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        calendar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dayNames.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(250)
        }
        infoBox.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(menuBar.snp.top).offset(-30)
        }
        addButton.snp.makeConstraints { (make) -> Void in
            make.trailing.bottom.equalTo(infoBox).inset(10)
            make.height.width.equalTo(80)
        }
    }
}

extension HomeController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let customCell = cell as! CalendarCell
        customCell.setNeedsUpdateConstraints()
        customCell.configure(text: cellState.text)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calCellReuseIdentifier, for: indexPath) as! CalendarCell
        cell.setNeedsUpdateConstraints()
        cell.configure(text: cellState.text)
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = labelColor
        }
        else {
            cell.dateLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        }
        handleCellSelection(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellSelection(cell: JTAppleCell?, cellState: CellState) {
        guard let customCell = cell as? CalendarCell else {
            return
        }
        if cellState.isSelected {
            customCell.selectedView.isHidden = false
        } else {
            customCell.selectedView.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "YYYY"
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "MM dd yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 01 2019")!
        let endDate = formatter.date(from: "01 31 2022")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}
