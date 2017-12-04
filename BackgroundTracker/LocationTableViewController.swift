//
//  LocationTableViewController.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 04.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var cl = CLLocationManager()
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateScreen), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        
        self.cl = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            cl.delegate = self
            cl.startUpdatingLocation()
            cl.startMonitoringSignificantLocationChanges()
        } else {
            cl.requestAlwaysAuthorization()
        }

        tableView.tableFooterView = UIView()
        self.updateScreen()
    }
    
    @objc func updateScreen(){
        print("#################################################################")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fr: NSFetchRequest<Location> = Location.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        
        do {
            self.locations = try context.fetch(fr)
        } catch {
            print("Ooops.")
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.locations.count > 0 ? self.locations.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCellID", for: indexPath)

        // Configure the cell...
        if self.locations.isEmpty {
            cell.textLabel?.text = "No locations in database"
            cell.detailTextLabel?.text = ""
            return cell
        }
        let latitude = self.locations[indexPath.row].latitude
        let longitude = self.locations[indexPath.row].longitude
        let rawDate = self.locations[indexPath.row].date!
        let date = DateFormatter.localizedString(from: rawDate as Date, dateStyle: .medium, timeStyle: .medium)
        cell.textLabel?.text = "\(latitude)\(longitude)"
        cell.detailTextLabel?.text = date

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            frc.managedObjectContext.delete(frc.object(at: indexPath))
            try! frc.managedObjectContext.save()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            tableView.insertRows(at: [indexPath], with: .fade)
        }    
    }
    */

/*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        tableView.moveRow(at: fromIndexPath, to: to)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
*/

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension LocationTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let ed = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let location = Location(entity: ed!, insertInto: context)
        location.date = Date() as NSDate
        location.longitude = (locations.last?.coordinate.longitude)!
        location.latitude = (locations.last?.coordinate.latitude)!
        try! context.save()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.cl.startUpdatingLocation()
        }
    }
}