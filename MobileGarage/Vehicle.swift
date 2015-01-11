//
//  Vehicle.swift
//  MobileGarage
//
//  Created by Andrew on 11/16/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

import Foundation

class Vehicle : NSObject {
    
    private var vin : String
    private var model: String
    private var make: String
    private var year: UInt
    private var mileage: UInt
    private var weeklyDistance: Float = 0
    private var lastMileageUpdate = nil as NSDate?
    
    var VIN : String { get { return self.vin } }
    var Model: String { get { return self.model } }
    var Make: String { get { return self.make } }
    var Year: UInt { get { return self.year } }
    var Mileage: UInt {
        get { return self.mileage }
        set(updatedMileage) { mileage = updatedMileage }
    }
    var WeeklyDistance: Float {
        get { return self.weeklyDistance }
        set(updatedWeeklyMileage) { self.weeklyDistance = updatedWeeklyMileage }
    }
    var LastMileageUpdate: NSDate? {
        get { return self.lastMileageUpdate }
        set(mileageUpdate) { self.lastMileageUpdate = mileageUpdate }
    }
    
    init(year : UInt, make : String, model : String, vin : String, mileage: UInt, weeklyDistance: Float = 0, lastMileageUpdate: NSDate? = nil) {
        
        self.vin = vin
        self.year = year
        self.make = make
        self.model = model
        self.mileage = mileage
        self.weeklyDistance = weeklyDistance
        self.lastMileageUpdate = lastMileageUpdate
    }
}