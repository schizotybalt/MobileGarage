//
//  PListUtils.swift
//  MobileGarage
//
//  Created by Andrew on 12/3/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

import Foundation

struct PListUtils {
    
    private var paths: String
    private let vehiclePListPath: String
    private let tuneupPListPath: String
    private var fileManager = NSFileManager.defaultManager()
    //    private let path = NSBundle.mainBundle().pathForResource("Vehicles", ofType: "plist")!
    
    private var vehicleDictionary: NSMutableDictionary
    private var tuneupDictionary: NSMutableDictionary
    
    init() {
        self.paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        self.vehiclePListPath = paths.stringByAppendingPathComponent("Vehicles.plist")
        self.tuneupPListPath = paths.stringByAppendingPathComponent("Tuneups.plist")
        
        if (!(fileManager.fileExistsAtPath(vehiclePListPath))) {
            var bundle : NSString = NSBundle.mainBundle().pathForResource("Vehicles", ofType: "plist")!
            fileManager.copyItemAtPath(bundle, toPath: vehiclePListPath, error:nil)
        }
        
        if (!(fileManager.fileExistsAtPath(tuneupPListPath))) {
            var bundle : NSString = NSBundle.mainBundle().pathForResource("Tuneups", ofType: "plist")!
            fileManager.copyItemAtPath(bundle, toPath: tuneupPListPath, error:nil)
        }
        
        vehicleDictionary = NSMutableDictionary(contentsOfFile: vehiclePListPath)!
        tuneupDictionary = NSMutableDictionary(contentsOfFile: tuneupPListPath)!
        println("vehicle PList Path \(vehiclePListPath)\n")
        println("tuneup PList Path \(tuneupPListPath)\n")
    }
    
    func writeToPList(vehicle: Vehicle) {
        
        var lastUpdateMileage = "" as String?
        
        if vehicle.LastMileageUpdate != nil {
            lastUpdateMileage = vehicle.LastMileageUpdate?.description
        }
        
        vehicleDictionary.setObject(["Year": vehicle.Year, "Make": vehicle.Make as NSString, "Model": vehicle.Model as NSString, "Mileage": vehicle.Mileage, "WeeklyDistance": vehicle.WeeklyDistance, "LastMileageUpdate": lastUpdateMileage!], forKey: vehicle.VIN)
        
        vehicleDictionary.writeToFile(vehiclePListPath, atomically: true)
        println("\(vehicle.Year) \(vehicle.Make) \(vehicle.Model) written to \(vehiclePListPath)\n")
    }
    
    func writeToPList(newTuneup: MaintenanceEvent) {
        
        var tuneups = self.tuneups(newTuneup.VIN) as NSMutableDictionary
        
        tuneups.setObject(["Interval": newTuneup.MileageInterval, "Description": newTuneup.EventDescription, "LastPerformed": newTuneup.LastPerformed!], forKey: newTuneup.UUIDString)
        
        tuneupDictionary.setObject(tuneups, forKey: newTuneup.VIN)
        tuneupDictionary.writeToFile(tuneupPListPath, atomically: true)
        println("\(newTuneup.EventDescription) every \(newTuneup.MileageInterval) for \(newTuneup.VIN) written to \(tuneupPListPath)")
    }
    
    func vehicle(vin: NSString) -> Vehicle {
        
        // originally this was a mutable dictionary but then vehicleDictionary was made private.
        // this created a low level error when casting vehicleDictionary[vin] to an NSMutableArray.
        // maybe it works now because i'm not trying to cast it to a mutable dictionary.
        var vehicleSpecs = vehicleDictionary[vin] as NSDictionary
        
        let dateFormatter = NSDateFormatter()
        // value	__NSCFString *	@"2014-12-10 14:17:07 +0000"
        // http://userguide.icu-project.org/formatparse/datetime
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss X"
        
        let vehicle = Vehicle(year: vehicleSpecs["Year"] as UInt,
            make: vehicleSpecs["Make"] as String,
            model: vehicleSpecs["Model"] as String,
            vin: vin,
            mileage: vehicleSpecs["Mileage"] as UInt,
            weeklyDistance: vehicleSpecs["WeeklyDistance"] as Float,
            lastMileageUpdate: dateFormatter.dateFromString(vehicleSpecs["LastMileageUpdate"] as String)
        )
        //        println("retrived \(vehicle.Year) \(vehicle.Make) \(vehicle.Model) from \(path)")
        return vehicle
        //        return Vehicle(year: 2005, make: "Hyundai", model: "Elantra", vin: "3OGH348H", mileage: 107000, weeklyDistance: 500)
    }
    
    func tuneups(VIN: String) -> NSDictionary {
        if tuneupDictionary.count > 0 {
            var tuneupDictForMyVehicle: AnyObject? = tuneupDictionary[VIN]
            
            if tuneupDictForMyVehicle == nil {
                return NSMutableDictionary()
            }
            return tuneupDictForMyVehicle as NSDictionary
        } else {
            return NSMutableDictionary()
        }
    }
    
    func tuneup(VIN: String, UUIDString: String) -> MaintenanceEvent {
        var tuneupInfo = tuneups(VIN)[UUIDString] as NSDictionary
        
        let tuneup = MaintenanceEvent(mileageInterval: tuneupInfo["Interval"] as UInt, eventDescription: tuneupInfo["Description"] as String, uuidString: UUIDString as String, vin: VIN as String, lastPerformed: tuneupInfo["LastPerformed"] as NSDate?)
        
        return tuneup
    }
    
    func vehicle(index: Int) -> Vehicle {
        let vin = (vehicleDictionary.allKeys)[index] as NSString
        return vehicle(vin)
    }
    
    func tuneup(VIN: String, index: Int) -> MaintenanceEvent {
        let uuidString = tuneups(VIN).allKeys[index] as NSString
        return tuneup(VIN, UUIDString: uuidString)
    }
    
    func vehicleCount() -> Int {
        //        println("vehicleDictionary.count == \(vehicleDictionary.count)")
        return vehicleDictionary.count
    }
    
    func tuneupCount(VIN: String) -> Int {
        //        println("vehicleDictionary.count == \(vehicleDictionary.count)")
        return tuneups(VIN).count
    }
}