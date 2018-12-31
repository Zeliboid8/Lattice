//
//  CalendarController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/19/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SnapKit

class CalendarController: UIViewController {
    
    var calendar: JTAppleCalendarView!
    var dayNames: UIStackView!
    var sunday: UILabel!
    var monday: UILabel!
    var tuesday: UILabel!
    var wednesday: UILabel!
    var thursday: UILabel!
    var friday: UILabel!
    var saturday: UILabel!
    
    var yearLabel: UILabel!
    var monthLabel: UILabel!
    var backButton: UIButton!
    
    let formatter = DateFormatter()
    
    let buttonOffset: CGFloat = 8
    let calCellReuseIdentifier = "calCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        view.insertSubview(blurEffectView, at: 0)
        
        yearLabel = UILabel()
        yearLabel.textColor = .white
        yearLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(yearLabel)
        
        monthLabel = UILabel()
        monthLabel.textColor = .white
        monthLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(monthLabel)
        
        // Setting up day name labels
        sunday = UILabel()
        sunday.text = "Sun"
        sunday.textAlignment = .center
        sunday.textColor = .white
        monday = UILabel()
        monday.text = "Mon"
        monday.textAlignment = .center
        monday.textColor = .white
        tuesday = UILabel()
        tuesday.text = "Tue"
        tuesday.textAlignment = .center
        tuesday.textColor = .white
        wednesday = UILabel()
        wednesday.text = "Wed"
        wednesday.textAlignment = .center
        wednesday.textColor = .white
        thursday = UILabel()
        thursday.text = "Thu"
        thursday.textAlignment = .center
        thursday.textColor = .white
        friday = UILabel()
        friday.text = "Fri"
        friday.textAlignment = .center
        friday.textColor = .white
        saturday = UILabel()
        saturday.text = "Sat"
        saturday.textAlignment = .center
        saturday.textColor = .white
        
        // Adding to stack view to arrange nicely
        dayNames = UIStackView()
        dayNames.distribution = .fillEqually
        dayNames.addArrangedSubview(sunday)
        dayNames.addArrangedSubview(monday)
        dayNames.addArrangedSubview(tuesday)
        dayNames.addArrangedSubview(wednesday)
        dayNames.addArrangedSubview(thursday)
        dayNames.addArrangedSubview(friday)
        dayNames.addArrangedSubview(saturday)
        view.addSubview(dayNames)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "BackArrowWhite"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissModalView), for: .touchUpInside)
        view.addSubview(backButton)
        
        calendar = JTAppleCalendarView(frame: .zero)
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        calendar.showsHorizontalScrollIndicator = false
        calendar.scrollDirection = .horizontal
        calendar.minimumInteritemSpacing = 0
        calendar.minimumLineSpacing = 0
        calendar.isPagingEnabled = true
        calendar.register(CalendarCell.self, forCellWithReuseIdentifier: calCellReuseIdentifier)
        calendar.scrollToDate(Date(), animateScroll: false)
        calendar.selectDates([Date()])
        calendar.backgroundColor = .clear
        
        calendar.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "YYYY"
            self.yearLabel.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
            
        }
        view.addSubview(calendar)
        setUpConstraints()
    }
    
    func setUpConstraints() {
        backButton.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(buttonOffset)
            make.height.width.equalTo(30)
        }
        yearLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        monthLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(yearLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        dayNames.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(monthLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        calendar.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(dayNames.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(300)
        }
    }
    
    @objc func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
}
    
extension CalendarController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
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
            cell.dateLabel.textColor = .white
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
        yearLabel.text = formatter.string(from: date)
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
