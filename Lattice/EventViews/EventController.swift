//
//  EventController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/9/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit

class EventController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var radialGradient: RadialGradientView!
    var upcomingEventLabel: UILabel!
    var tableView: UITableView!
    var events: [Event]!
    var eventsDict: [Date: [Event]] = [:]
    var eventDates: [Date] = []
    var dateFormatter: DateFormatter!
    var timeFormatter: DateFormatter!
    
    let headerReuseIdentifier = "HeaderCell"
    let eventReuseIdentifier = "EventCell"
    let headerHeight: CGFloat = 30
    let footerHeight: CGFloat = 30
    let cellHeight: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()

        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        importEvents()

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        upcomingEventLabel = UILabel()
        upcomingEventLabel.text = "Upcoming Events"
        upcomingEventLabel.font = UIFont(name: "Nunito-Regular", size: 40)
        upcomingEventLabel.textColor = Colors.labelColor
        view.addSubview(upcomingEventLabel)

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: eventReuseIdentifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        setupConstraints()
    }

    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        upcomingEventLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(upcomingEventLabel.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalTo(view).inset(10)
        }
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
        var unsortedDates: [Date] = []
        for date in eventsDict.keys {
            unsortedDates.append(date)
        }
        eventDates = unsortedDates.sorted()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! HeaderView
        header.configure(dayName: dateFormatter.string(from: eventDates[section]))
        header.setNeedsUpdateConstraints()
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsDict[eventDates[section]]?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return eventsDict.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventReuseIdentifier, for: indexPath) as! EventCell
        let event: Event = (eventsDict[eventDates[indexPath.section]]?[indexPath.row])!
        let eventTitle = event.event_name
        let eventStartTime = timeFormatter.string(from: event.start_date)
        let eventEndTime = timeFormatter.string(from: event.end_date)
        let eventTime = "\(eventStartTime) to \(eventEndTime)"
        cell.configure(eventTitle: eventTitle, eventTime: eventTime)
        cell.setNeedsUpdateConstraints()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
