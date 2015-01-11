//
//  DataViewController.swift
//  MobileGarage
//
//  Created by Andrew on 11/16/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

import UIKit
import CloudKit
/*
extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}*/

class AddVehicleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var yearField : UITextField!
    @IBOutlet var makeField : UITextField!
    @IBOutlet var modelField : UITextField!
    @IBOutlet var vinField : UITextField!
    @IBOutlet var mileageField : UITextField!
    @IBOutlet var doneButton : UIBarButtonItem!
    
    private var pListUtils = PListUtils()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // for dismissing keyboard.
        yearField.delegate = self
        makeField.delegate = self
        modelField.delegate = self
        vinField.delegate = self
        mileageField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    @IBAction func addNewVehicleToPList(sender: AnyObject) {
        
        if sender as? NSObject != self.doneButton{
            return
        }
        
        let year = UInt(yearField.text.toInt()!)
        let make = makeField.text
        let model = modelField.text
        let vin = vinField.text
        let mileage = UInt(mileageField.text.toInt()!)
        
        var newVehicle =  Vehicle(year: year, make: make, model: model, vin: vin, mileage: mileage)
        newVehicle.LastMileageUpdate = NSDate()
        pListUtils.writeToPList(newVehicle)
        
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
            
        case .OrderedSame, .OrderedDescending:
            println("iOS >= 8.0")
            syncWithICloud(newVehicle)
            
        case .OrderedAscending:
            println("iOS < 8.0")
        }
    }
    
    func syncWithICloud(newVehicle: Vehicle) {
        
        // from gist
        // general cloudkit container
        /* Note: make into property */
        var container: CKContainer = CKContainer.defaultContainer()
        
        // setup our new record
        let newVehicleRecord = CKRecord(recordType: "Vehicle", recordID: CKRecordID(recordName: newVehicle.VIN))
        newVehicleRecord.setValue(newVehicle.VIN, forKey: "VIN")
        newVehicleRecord.setValue(newVehicle.Make, forKey: "Make")
        newVehicleRecord.setValue(newVehicle.Model, forKey: "Model")
        newVehicleRecord.setValue(newVehicle.Year, forKey: "Year")
        newVehicleRecord.setValue(newVehicle.Mileage, forKey: "Mileage")
        newVehicleRecord.setValue(newVehicle.WeeklyDistance, forKey: "WeeklyDistance")
        newVehicleRecord.setValue(newVehicle.LastMileageUpdate, forKey: "LastMileageUpdate")
        
        var saveOp = CKModifyRecordsOperation(recordsToSave: [newVehicleRecord], recordIDsToDelete: nil)
        saveOp.start()
        
        // the stuff below may work alternatively.
        /*
        // save the record in a public database
        container.privateCloudDatabase.saveRecord(newVehicleRecord) {
        (record, error) -> Void in
        
        if error != nil {
        println(error)
        return
        }
        
        println("\(newVehicle.Make) \(newVehicle.Model) saved to private DB")
        println(record)
        }*/
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //first write the new vehicle to the plist.  the done button's been
        // ctrl-dragged to addNewVehicleToPList but that's being skipped.
        // this method isn't so we'll have to call it here i guess.
        addNewVehicleToPList(sender!)
        
        if segue.destinationViewController.isKindOfClass(VehicleViewController) {
            
            let vehicleViewController: VehicleViewController = segue.destinationViewController as VehicleViewController
            
            // Pass the selected object to the new view controller.
            vehicleViewController.MyVehicle = pListUtils.vehicle(vinField.text)
        }
    }
    
    // for dismissing the keyboard.
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}