//
//  DataViewController.swift
//  MobileGarage
//
//  Created by Andrew on 11/16/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class AddTuneupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var intervalField : UITextField!
    @IBOutlet var descriptionField : UITextField!
    @IBOutlet var doneButton : UIBarButtonItem!
    @IBOutlet var datePicker: UIDatePicker!
    
    private var pListUtils = PListUtils()
    var VIN = nil as String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // for dismissing keyboard.
        intervalField.delegate = self
        descriptionField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    @IBAction func addNewTuneupToPList(sender: UIBarButtonItem?) {
        
        // this is triggered even when sender == doneButton so @$%& it.
        /*
        if sender != self.doneButton{
            return
        }*/
        
        let interval = UInt(intervalField.text.toInt()!)
        let description = descriptionField.text
        let uuid = NSUUID().UUIDString
        let lastPerformed = datePicker.date
        
        var newTuneup = MaintenanceEvent(mileageInterval: interval, eventDescription: description, uuidString: uuid, vin: VIN!, lastPerformed: lastPerformed)
        
        pListUtils.writeToPList(newTuneup)
        
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            println("iOS >= 8.0")
//            syncWithICloud(newTuneup)
            
        case .OrderedAscending:
            println("iOS < 8.0")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController.isKindOfClass(TuneupUITableViewController) {
            
            let tuneupUITableViewController: TuneupUITableViewController = segue.destinationViewController as TuneupUITableViewController
            
            // maybe not.
            // need to reconstruct because
//            let tuneupUITableViewController: TuneupUITableViewController = TuneupUITableViewController()
            
            tuneupUITableViewController.MyVehicle = pListUtils.vehicle(VIN!)
        }
        
        if sender as UIBarButtonItem  == self.doneButton{
            addNewTuneupToPList(sender! as? UIBarButtonItem)
        }
    }
    
    // for dismissing the keyboard.
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}