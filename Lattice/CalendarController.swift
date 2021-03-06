//
//  CalendarController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/8/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

class CalendarController: UIViewController {

    var radialGradient: RadialGradientView!
    var calendar: JTAppleCalendarView!
    var infoBox: UIView!
    var verticalBar: UIView!
    var infoBoxLabel: UILabel!
    var infoBoxSubtitle: UILabel!
    var dayNames: UIStackView!
    var monthLabel: UILabel!
    var events: [Event]!
    var eventsDict: [Date : [Event]] = [:]
    var importButton: AddButton!
    var blockCalendarButton: AddButton!
    var buttonStackView: UIStackView!
    
    let formatter = DateFormatter()
    let dayTitles = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let calCellReuseIdentifier = "calCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showButtons))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        importButton = AddButton()
        importButton.configure(image: UIImage(named: "Import")!.withRenderingMode(.alwaysTemplate), title: "Import")
        importButton.imageView?.tintColor = Colors.labelColor
        importButton.titleLabel?.numberOfLines = 2
        importButton.backgroundColor = Colors.red
        
        blockCalendarButton = AddButton()
        blockCalendarButton.configure(image: UIImage(named: "BlockCalendar")!.withRenderingMode(.alwaysTemplate), title: "Block")
        blockCalendarButton.imageView?.tintColor = Colors.labelColor
        blockCalendarButton.titleLabel?.numberOfLines = 2
        blockCalendarButton.backgroundColor = Colors.blue
        blockCalendarButton.addTarget(self, action: #selector(pushBlockView), for: .touchUpInside)
        
        buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(importButton)
        buttonStackView.addArrangedSubview(blockCalendarButton)
        view.addSubview(buttonStackView)
        
        setupInfoBox()
        importEvents()
        setupCalendar()
        setupConstraints()
        
        infoBox.isHidden = true
        verticalBar.isHidden = true
        infoBoxLabel.isHidden = true
        infoBoxSubtitle.isHidden = true
        importButton.isHidden = false
        blockCalendarButton.isHidden = false
    }
    
    func importEvents() {
        events = EventManager.importEvents()
        for event in events {
            if Calendar.current.isDate(event.start_date, inSameDayAs: event.end_date) { // Event spans the same day
                if eventsDict[Calendar.current.startOfDay(for: event.start_date)] == nil {
                    eventsDict[Calendar.current.startOfDay(for: event.start_date)] = [event]
                } else {
                    eventsDict[Calendar.current.startOfDay(for: event.start_date)]?.append(event)
                }
            }
            else {
                // Add event to day the event starts on
                if eventsDict[Calendar.current.startOfDay(for: event.start_date)] == nil {
                    eventsDict[Calendar.current.startOfDay(for: event.start_date)] = [event]
                } else {
                    eventsDict[Calendar.current.startOfDay(for: event.start_date)]?.append(event)
                }
                // Add event to day the event ends on
                if eventsDict[Calendar.current.startOfDay(for: event.end_date)] == nil {
                    eventsDict[Calendar.current.startOfDay(for: event.end_date)] = [event]
                }
                else {
                    eventsDict[Calendar.current.startOfDay(for: event.end_date)]?.append(event)
                }
            }
        }
    }
    
    func setupCalendar() {
        monthLabel = UILabel()
        monthLabel.textColor = Colors.labelColor
        monthLabel.font = UIFont(name: "Nunito-Regular", size: 40)
        view.addSubview(monthLabel)
        
        // Setting up day name labels
        dayNames = UIStackView()
        dayNames.distribution = .fillEqually
        for day in dayTitles {
            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.textAlignment = .center
            dayLabel.textColor = Colors.labelColor
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
        infoBox.backgroundColor = Colors.infoBox
        infoBox.layer.cornerRadius = 8
        view.addSubview(infoBox)
        
        verticalBar = UIView()
        view.addSubview(verticalBar)
        
        infoBoxLabel = UILabel()
        infoBoxLabel.textColor = Colors.labelColor
        infoBoxLabel.font = UIFont(name: "Nunito-Semibold", size: 20)
        view.addSubview(infoBoxLabel)
        
        infoBoxSubtitle = UILabel()
        infoBoxSubtitle.font = UIFont(name: "Nunito-Italic", size: 15)
        view.addSubview(infoBoxSubtitle)
    }
    
    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        monthLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.height.equalTo(40)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30 - MenuBarParameters.menuBarHeight)
        }
        verticalBar.snp.makeConstraints { (make) -> Void in
            make.leading.top.bottom.equalTo(infoBox).inset(20)
            make.width.equalTo(3)
        }
        infoBoxLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(verticalBar.snp.trailing).offset(20)
            make.top.equalTo(infoBox).offset(20)
        }
        infoBoxSubtitle.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(verticalBar.snp.trailing).offset(20)
            make.top.equalTo(infoBoxLabel.snp.bottom).offset(5)
        }
        buttonStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30 - MenuBarParameters.menuBarHeight)
        }
    }
    
    @objc func showButtons() {
        calendar.deselectAllDates()
        infoBox.isHidden = true
        verticalBar.isHidden = true
        infoBoxLabel.isHidden = true
        infoBoxSubtitle.isHidden = true
        importButton.isHidden = false
        blockCalendarButton.isHidden = false
    }
    
    @objc func pushBlockView() {
        let blockController = BlockCalendarController()
        navigationController?.pushViewController(blockController, animated: true)
    }
}

extension CalendarController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let customCell = cell as! CalendarCell
        handleCellSetup(date: date, cellState: cellState, cell: customCell)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calCellReuseIdentifier, for: indexPath) as! CalendarCell
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = Colors.labelColor
        }
        else {
            cell.dateLabel.textColor = Colors.grayLabelColor
        }
        handleCellSetup(date: date, cellState: cellState, cell: cell)
        return cell
    }
    
    func handleCellSetup(date: Date, cellState: CellState, cell: CalendarCell) {
        cell.setNeedsUpdateConstraints()
        guard let filteredEvents = eventsDict[Calendar.current.startOfDay(for: date)] else {
            cell.configure(text: cellState.text, color: .clear)
            handleCellSelection(cell: cell, cellState: cellState, date: date, events: nil)
            return
        }
        if filteredEvents.count < 2 {
            cell.configure(text: cellState.text, color: colorFromAvailability(.some))
        } else {
            cell.configure(text: cellState.text, color: colorFromAvailability(.busy))
        }
        handleCellSelection(cell: cell, cellState: cellState, date: date, events: filteredEvents)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let filteredEvents = eventsDict[Calendar.current.startOfDay(for: date)]
        infoBox.isHidden = false
        verticalBar.isHidden = false
        infoBoxLabel.isHidden = false
        infoBoxSubtitle.isHidden = false
        importButton.isHidden = true
        blockCalendarButton.isHidden = true
        handleCellSelection(cell: cell, cellState: cellState, date: date, events: filteredEvents)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let filteredEvents = eventsDict[Calendar.current.startOfDay(for: date)]
        handleCellSelection(cell: cell, cellState: cellState, date: date, events: filteredEvents)
    }
    
    func handleCellSelection(cell: JTAppleCell?, cellState: CellState, date: Date, events: [Event]?) {
        guard let customCell = cell as? CalendarCell else {
            return
        }
        if cellState.isSelected {
            customCell.selectedView.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d"
            infoBoxLabel.text = ("\(dateFormatter.string(from: date))")
            if events == nil {
                verticalBar.backgroundColor = colorFromAvailability(.free)
                infoBoxSubtitle.textColor = colorFromAvailability(.free)
                infoBoxSubtitle.text = "No events"
            } else if events!.count < 2 {
                verticalBar.backgroundColor = colorFromAvailability(.some)
                infoBoxSubtitle.textColor = colorFromAvailability(.some)
                infoBoxSubtitle.text = "Some availability"
            } else {
                verticalBar.backgroundColor = colorFromAvailability(.busy)
                infoBoxSubtitle.textColor = colorFromAvailability(.busy)
                infoBoxSubtitle.text = "Little availability"
            }
        } else {
            customCell.selectedView.isHidden = true
        }
    }
    
    func colorFromAvailability(_ availability: Availability) -> UIColor {
        switch availability {
        case .free:
            return Colors.blue
        case .some:
            return Colors.yellow
        case .busy:
            return Colors.red
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

