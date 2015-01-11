//
//  ServiceUITableViewController.swift
//  MobileGarage
//
//  Created by Andrew on 12/8/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

import UIKit

class TuneupUITableViewController: UITableViewController {
    
    @IBOutlet var tuneupTableView : UITableView!
    
    private var pListUtils = PListUtils()
    var MyVehicle = nil as Vehicle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // maybe it does.
        // doesn't help.
        // reload new stuff after coming back from addcontroller.
        pListUtils = PListUtils()
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pListUtils.tuneupCount(MyVehicle!.VIN)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProtoCell", forIndexPath: indexPath) as UITableViewCell
        
        let tuneup = pListUtils.tuneup(MyVehicle!.VIN, index: indexPath.row)
        var estimationDateComps = NSDateComponents()
        
        let weeksUntilTuneup = Float(tuneup.MileageInterval) / Float(MyVehicle!.WeeklyDistance)
        
        if weeksUntilTuneup != Float.infinity {
            estimationDateComps.day = Int(weeksUntilTuneup * 7)
            var calendar = NSCalendar.currentCalendar()
            let estimatedTuneUpDate = calendar.dateByAddingComponents(estimationDateComps, toDate: tuneup.LastPerformed!, options: nil)
            cell.textLabel?.text = "\(tuneup.EventDescription) due \(estimatedTuneUpDate!.description)"
            
            let now = NSDate()
//            var dateCompare = now.compare(estimatedTuneUpDate)
//            let tuneupOverdue = dateCompare ==
            
            // if estimatedTuneUpDate.hasAlreadyHappened {
            if false {
                let notification = UILocalNotification()
                notification.alertAction = "Next Oil Change"
                notification.alertBody = "Oil Change Needed Soon"
                notification.fireDate = NSDate(timeInterval: 0, sinceDate: now)
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        } else {
            cell.textLabel?.text = "No need for that \(tuneup.EventDescription).  You don't even drive your car."
        }
        
        //        let now = NSDate()
        
        //        var dateComps = calender.components(NSCalendarUnit.DayCalendarUnit, fromDate: tuneup.LastPerformed!, toDate: now, options: nil)
        //        var daysSinceLastTuneup = Float(dateComps.day)
        
        //        let mileageAdjustment = Float(MyVehicle!.WeeklyDistance) * (daysSinceLastTuneup / 7.0)
        //        let adjustedMileage = MyVehicle!.Mileage + UInt(mileageAdjustment)
        //        let
        
        //        cell.textLabel?.text = "\(tuneup.EventDescription) every \(tuneup.MileageInterval): due on [someday]"
        
        // don't know what this does in the garage controller.
        //        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) { }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController.isKindOfClass(AddTuneupViewController) {
            
            let addTuneupViewController: AddTuneupViewController = segue.destinationViewController as AddTuneupViewController
            
            addTuneupViewController.VIN = MyVehicle!.VIN
        }
        
        if segue.destinationViewController.isKindOfClass(VehicleViewController) {
            
            let vehicleViewController: VehicleViewController = segue.destinationViewController as VehicleViewController
            
            // Pass the selected object to the new view controller.
            vehicleViewController.MyVehicle = MyVehicle
        }
    }
}