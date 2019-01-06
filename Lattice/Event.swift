//
//  Event.swift
//  Lattice
//
//  Created by Eli Zhang on 1/6/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import Foundation

class RawEvent: Codable {
    var event_id: Int
    var event_name: String
    var start_date: String // Formatted in year-month-dayThour:minutes:seconds
    var end_date: String // Formatted in year-month-dayThour:minutes:seconds
    var location: String
    var is_private: Bool
    
    init(event_id: Int, event_name: String, start_date: String, end_date: String, location: String, is_private: Bool) {
        self.event_id = event_id
        self.event_name = event_name
        self.start_date = start_date
        self.end_date = end_date
        self.location = location
        self.is_private = is_private
    }
}

class Event {
    var event_id: Int
    var event_name: String
    var start_date: Date // Formatted in year-month-dayThour:minutes:seconds
    var end_date: Date // Formatted in year-month-dayThour:minutes:seconds
    var location: String
    var is_private: Bool
    
    init(event: RawEvent) {
        let calendar = Calendar(identifier: .gregorian)
        let eventStart: String = event.start_date
        let startComponents = eventStart.split(separator: "T", maxSplits: 1)
        let startDate = String(startComponents[0]).split(separator: "-")
        let startTime = String(startComponents[1]).split(separator: ":")
        
        var startDateComponents = DateComponents()
        startDateComponents.year = Int(startDate[0])
        startDateComponents.month = Int(startDate[1])
        startDateComponents.day = Int(startDate[2])
        startDateComponents.hour = Int(startTime[0])
        startDateComponents.minute = Int(startTime[1])
        startDateComponents.second = Int(startTime[2])
        self.start_date = calendar.date(from: startDateComponents)!
        
        let eventEnd: String = event.end_date
        let endComponents = eventEnd.split(separator: "T", maxSplits: 1)
        let endDate = String(endComponents[0]).split(separator: "-")
        let endTime = String(endComponents[1]).split(separator: ":")
        
        var endDateComponents = DateComponents()
        endDateComponents.year = Int(endDate[0])
        endDateComponents.month = Int(endDate[1])
        endDateComponents.day = Int(endDate[2])
        endDateComponents.hour = Int(endTime[0])
        endDateComponents.minute = Int(endTime[1])
        endDateComponents.second = Int(endTime[2])
        self.end_date = calendar.date(from: endDateComponents)!
        
        self.event_id = event.event_id
        self.event_name = event.event_name
        self.location = event.location
        self.is_private = event.is_private
    }
}
