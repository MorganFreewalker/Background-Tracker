//
//  LocationTableViewController.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 04.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import UIKit
import CoreData

protocol LocationTableViewControllerProtocol: UITableViewDelegate {
    var presenter: PresenterProtocol? {get set}
    func updateScreen()
}

class LocationTableViewController: UITableViewController, LocationTableViewControllerProtocol {
    
    var presenter: PresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.tableFooterView = UIView()
    }
    
    func updateScreen(){
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
        return presenter?.numberOfRowAt(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCellID", for: indexPath)
        
        // Configure the cell...
        if let location = presenter?.locationForCellAt(indexPath: indexPath) {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let rawDate = location.date
            let date = DateFormatter.localizedString(from: rawDate as Date, dateStyle: .medium, timeStyle: .medium)
            cell.textLabel?.text = "\(latitude) \(longitude)"
            cell.detailTextLabel?.text = date
        }
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return presenter?.canDeleteCell ?? false
    }
    

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
