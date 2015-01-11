//
//  GarageViewController.swift
//  MobileGarage
//
//  Created by Andrew on 11/18/14.
//  Copyright (c) 2014 iOS Fall 2014 MobileGarage Team. All rights reserved.
//

import UIKit

class GarageViewController: UITableViewController {

    @IBOutlet var carTableView : UITableView!
    
    private var selectedVin = ""
    private var pListUtils = PListUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        pListUtils = PListUtils()
        tableView.reloadData()
        
        //        self.registerViewClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // this claims there were zero sections in the tableView.  the cells weren't being populated.
    // was this in a shfoolish example or part of the tableViewController template?
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
*/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pListUtils.vehicleCount()
    }
    
    // http://www.raywenderlich.com/76519/add-table-view-search-swift
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProtoCell", forIndexPath: indexPath) as UITableViewCell
        let vehicle = pListUtils.vehicle(indexPath.row)
        
        let year = vehicle.Year
        let make = vehicle.Make
        let model = vehicle.Model
        
        cell.textLabel?.text = "\(vehicle.Year) \(vehicle.Make) \(vehicle.Model)"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    @IBAction override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vehicle = pListUtils.vehicle(indexPath.row)
        selectedVin = vehicle.VIN
        self.performSegueWithIdentifier("SelectedVehicleSegue", sender: self)
        /*
        // verification code
        let alert = UIAlertController(title: "Item selected", message: "You selected item \(indexPath.row)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: {
                (alert: UIAlertAction!) in println("An alert of type \(alert.style.hashValue) was tapped!")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        */
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController.isKindOfClass(VehicleViewController) {
            
            let vehicleViewController: VehicleViewController = segue.destinationViewController as VehicleViewController
            
            // Pass the selected object to the new view controller.
            vehicleViewController.MyVehicle = pListUtils.vehicle(selectedVin)
        }
    }
}