//
//  CheckVehicle.swift
//  MobileGarage
//
//  Created by Andrew on 11/16/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

/**************************************************************************
To view updated location:

Go to Xcode->Preferences
Go to behaviors
For each option, select "Show debugger with console view"
Build the solution with the play button instead of keyboard shortcuts
Navigate to the My Vehicle Page
Click on Start Trip
Select Debug->Location->(select an option)
**************************************************************************/

import UIKit
import CoreLocation

class VehicleViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
//    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet var rightBarButton: UIBarButtonItem!
    
    @IBOutlet var startTripButton: [UIButton]!
    @IBOutlet var resetTripButton: [UIButton]!
    @IBOutlet var tripsStepper: UIStepper!
    @IBOutlet var tripsLabel: UILabel!
    @IBOutlet var tripDistanceLabel: UILabel!
    
    @IBOutlet var yearField : UITextField!
    @IBOutlet var makeField : UITextField!
    @IBOutlet var modelField : UITextField!
    @IBOutlet var vinField : UITextField!
    @IBOutlet var mileageField : UITextField!
    @IBOutlet var weeklyDistanceField : UITextField!
    @IBOutlet var weeklyDistanceLabel: UILabel!
    
    var MyVehicle = nil as Vehicle?
    private var pListUtils = PListUtils()
    
    lazy var locationManager: CLLocationManager = {
        
        var manager = CLLocationManager()
        
        // causes error on my iphone 4
//        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        return manager
        }()
    
    var TripDistance = 0.0
    let metersMilesCoefficient = 0.000621371
    let meteresFeetCoefficient = 3.28084
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for notifications, setup so the user can select
        if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings:") {
            UIApplication.sharedApplication().registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
        // turn off save button because no changes have been made yet.
        navigationItem.rightBarButtonItems?.removeAtIndex(0)
        
        // for dismissing keyboard.
        mileageField.delegate = self
        weeklyDistanceField.delegate = self
        
        // so "Weekly Distance" wraps to 2nd line of label.
        weeklyDistanceLabel.numberOfLines = 0
        
        tripsStepper.value = 10
        tripsLabel.text = tripsStepper.value.description
        
        yearField.text = MyVehicle!.Year.description
        makeField.text = MyVehicle!.Make
        modelField.text = MyVehicle!.Model
        vinField.text = MyVehicle!.VIN
        mileageField.text = MyVehicle!.Mileage.description
        weeklyDistanceField.text = MyVehicle!.WeeklyDistance.description
    }
    
    @IBAction func startTripTapped(startTripButton: UIButton) {
        
        //WeeksToNextOilChange = (NextOilChangeMilage-CurrentMileage)/WeeklyDistance
        //NSDate TimeToChangeOil = now + WeeksToNextOilChange
        //notification.fireDate = NSDate(timeInterval: 0, sinceDate: TimeToChangeOil))
        
        if startTripButton.titleLabel?.text == "Start Trip" {
            
            startTripButton.setTitle("Stop Trip", forState: .Normal)
            locationManager.startUpdatingLocation()
            println("updating location")
        }
        else {
            startTripButton.setTitle("Start Trip", forState: .Normal)
            locationManager.stopUpdatingLocation()
            weeklyDistanceField.text = (TripDistance * tripsStepper.value * metersMilesCoefficient).description
            
            // weekly mileage updated->now you can save.
            navigationItem.rightBarButtonItems?.insert(rightBarButton, atIndex: 0)
        }
    }
    
    @IBAction func stepTrips(sender: UIStepper) {
        tripsLabel.text = Int(tripsStepper.value).description
    }
    
    @IBAction func resetTrips(sender: UIButton) {
        
        TripDistance = 0
        tripDistanceLabel.text = "\(TripDistance.description) miles"
        weeklyDistanceField.text = (TripDistance).description
    }
    
    var previousLocation = nil as CLLocation?
    
    //    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]!) {
        
        // uncomment this to see that there seems to only ever be 1 element in the array.
        //        println("\(locations.count - 1) segments")
        
        let location = locations.last
        println("location: \(location)")
        
        //        let startloc = locations[locations.startIndex] as CLLocation
        //        println(startloc)
        
        if previousLocation != nil {
            var segmentDistance = previousLocation!.distanceFromLocation(location)
            println("speed: \(segmentDistance) m/s (\(segmentDistance * meteresFeetCoefficient) f/s)")
            
            TripDistance += segmentDistance
            println("trip distance: \(TripDistance)")
            
            let tripMileage = TripDistance * metersMilesCoefficient;println("trip Mileage: \(tripMileage)")
            let integralTripMileage = Int(tripMileage);println("integral Trip Mileage: \(integralTripMileage)")
            let tripFeet = (tripMileage - Double(integralTripMileage)) * 5280;println("trip Feet: \(tripFeet)")
            
            var mileageLabel =  "\(integralTripMileage.description) mile"
            
            if integralTripMileage > 1 {
                mileageLabel.append("s" as Character)
            } /*else {
                if integralTripMileage < 1 {
                    mileageLabel = "      "
                }
            }*/
            
            tripDistanceLabel.text = "\(mileageLabel) \(Int(tripFeet)) feet"
        }
        previousLocation = location
        println("previous location : \(previousLocation)\n")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error while updating location " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // for dismissing the keyboard.
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func mileageChanged(sender: UITextField) {
        
        // duplicate save button bug.
        navigationItem.rightBarButtonItems?.removeAll(keepCapacity: true)
        
        // mileage updated->now you can save.
        navigationItem.rightBarButtonItems?.insert(rightBarButton, atIndex: 0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController.isKindOfClass(TuneupUITableViewController) {
            
            let tuneupUITableViewController: TuneupUITableViewController = segue.destinationViewController as TuneupUITableViewController
            
            tuneupUITableViewController.MyVehicle = MyVehicle
        }
    }
    
    @IBAction func SaveMileageChanges() {
        
        MyVehicle?.Mileage = UInt(mileageField.text.toInt()!)
        MyVehicle?.WeeklyDistance = (weeklyDistanceField.text as NSString).floatValue
        MyVehicle?.LastMileageUpdate = NSDate()
        
        pListUtils.writeToPList(MyVehicle!)
        
        navigationItem.rightBarButtonItems?.removeAll(keepCapacity: true)
    }
}