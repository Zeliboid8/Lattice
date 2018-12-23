//
//  CalendarViewController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/19/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SnapKit

class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    var calendar: JTAppleCalendarView!
    let formatter = DateFormatter()
    let calCellReuseIdentifier = "calCellReuseIdentifier"
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let customCell = cell as! CalendarCollectionViewCell
        customCell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calCellReuseIdentifier, for: indexPath) as! CalendarCollectionViewCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "mm dd yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 01 2019")!
        let endDate = formatter.date(from: "01 31 2019")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        calendar = JTAppleCalendarView()
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        calendar.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: calCellReuseIdentifier)
        calendar.cellSize = 20
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        view.addSubview(calendar)
        setUpConstraints()
    }
    
    func setUpConstraints() {
        calendar.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(200)
        }
    }
}
