//
//  EventController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/9/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit

class EventController {//: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var upcomingEventLabel: UILabel!
//    var tableView: UITableView!
//    let headerReuseIdentifier = "HeaderCell"
//    let eventReuseIdentifier = "EventCell"
//    var events: [Event]!
//    var eventsDict: [Date: [Event]] = [:]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        importEvents()
//        
//        upcomingEventLabel = UILabel()
//        upcomingEventLabel.font = UIFont(name: "Nunito-Regular", size: 40)
//        upcomingEventLabel.textColor = Colors.labelColor
//        view.addSubview(upcomingEventLabel)
//        
//        tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(HeaderEventCell.self, forCellReuseIdentifier: headerReuseIdentifier)
//        tableView.register(EventCell.self, forCellReuseIdentifier: eventReuseIdentifier)
//        view.addSubview(tableView)
//        setupConstraints()
//    }
//    
//    func setupConstraints() {
//        upcomingEventLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
//            make.height.equalTo(40)
//        }
//    }
//    
//    func importEvents() {
//        events = EventManager.importEvents()
//        for event in events {
//            if Calendar.current.isDate(event.start_date, inSameDayAs: event.end_date) { // Event spans the same day
//                if eventsDict[Calendar.current.startOfDay(for: event.start_date)] == nil {
//                    eventsDict[Calendar.current.startOfDay(for: event.start_date)] = [event]
//                } else {
//                    eventsDict[Calendar.current.startOfDay(for: event.start_date)]?.append(event)
//                }
//            }
//            else {
//                // Add event to day the event starts on
//                if eventsDict[Calendar.current.startOfDay(for: event.start_date)] == nil {
//                    eventsDict[Calendar.current.startOfDay(for: event.start_date)] = [event]
//                } else {
//                    eventsDict[Calendar.current.startOfDay(for: event.start_date)]?.append(event)
//                }
//                // Add event to day the event ends on
//                if eventsDict[Calendar.current.startOfDay(for: event.end_date)] == nil {
//                    eventsDict[Calendar.current.startOfDay(for: event.end_date)] = [event]
//                }
//                else {
//                    eventsDict[Calendar.current.startOfDay(for: event.end_date)]?.append(event)
//                }
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return eventsDict.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderCell
//        return cell
//    }

}
