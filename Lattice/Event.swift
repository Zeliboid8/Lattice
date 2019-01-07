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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.start_date = dateFormatter.date(from: event.start_date)!
        self.end_date = dateFormatter.date(from: event.end_date)!
        self.event_id = event.event_id
        self.event_name = event.event_name
        self.location = event.location
        self.is_private = event.is_private
    }
}
