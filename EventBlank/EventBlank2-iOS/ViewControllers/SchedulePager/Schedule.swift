//
//  Schedule.swift
//  EventBlank2-iOS
//
//  Created by Marin Todorov on 4/9/16.
//  Copyright © 2016 Underplot ltd. All rights reserved.
//

import Foundation
import RealmSwift
import AFDateHelper

class Schedule {
    struct Day {
        let startTime: NSDate
        let endTime: NSDate
        let text: String
    }

    private lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EE, MMM dd"
        return dateFormatter
    }()
    
    func dayRanges() -> [Day] {
        let sessions = RealmProvider.eventRealm.objects(Session).sorted("beginTime", ascending: true)
        
        precondition(sessions.first!.beginTime != nil)
        
        let eventBeginDate = sessions.first!.beginTime!.dateAtStartOfDay()
        let eventEndDate = sessions.last!.beginTime!.dateAtEndOfDay()
        
        let nrOfDays = eventEndDate.daysAfterDate(eventBeginDate)
        
        return (0...nrOfDays).map {i in
            let dayDate = eventBeginDate.dateByAddingDays(i)
            return Day(
                startTime: dayDate.dateAtStartOfDay(),
                endTime: dayDate.dateAtEndOfDay(),
                text: dateFormatter.stringFromDate(dayDate))
        }
    }
}