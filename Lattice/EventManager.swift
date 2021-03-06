//
//  EventManager.swift
//  Lattice
//
//  Created by Eli Zhang on 1/6/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

class EventManager {
    static func importEvents() -> [Event] {
        let event1 = RawEvent(event_id: 0, event_name: "Moseying around in a field", start_date: "2019-1-5T03:30:00", end_date: "2019-1-5T06:00:00", location: "a field somewhere", is_private: false)
        let event2 = RawEvent(event_id: 0, event_name: "looking for quacking ducks", start_date: "2019-1-10T03:30:00", end_date: "2019-1-10T06:00:00", location: "a field somewhere", is_private: false)
        let processedEvent1 = Event(event: event1)
        let processedEvent2 = Event(event: event2)
        var eventArray: [Event] = []
        eventArray.append(processedEvent1)
        eventArray.append(processedEvent2)
        return eventArray.sorted(by: { $0.start_date < $1.start_date })
    }
}
