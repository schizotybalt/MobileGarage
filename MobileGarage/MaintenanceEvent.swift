//
//  MaintenanceEvent.swift
//  MobileGarage
//
//  Created by Andrew on 12/7/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

import Foundation

class MaintenanceEvent : NSObject {
    
    private var mileageInterval: UInt
    private var eventDescription: String
    private var uuidString: String
    private var vin: String
    private var lastPerformed = nil as NSDate?
    
    var MileageInterval: UInt { get { return mileageInterval } }
    var EventDescription: String { get { return eventDescription } }
    var UUIDString: String { get { return uuidString } }
    var VIN: String { get { return vin } }
    var LastPerformed: NSDate? { get { return self.lastPerformed } }
    
    init(mileageInterval: UInt, eventDescription: String, uuidString: String, vin: String, lastPerformed: NSDate? = nil) {
        self.mileageInterval = mileageInterval
        self.eventDescription = eventDescription
        self.uuidString = uuidString
        self.vin = vin
        self.lastPerformed = lastPerformed
    }
}