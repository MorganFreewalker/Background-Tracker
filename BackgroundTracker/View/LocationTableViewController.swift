//
//  LocationTableViewController.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 04.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import UIKit
import CoreData

protocol LocationTableViewControllerProtocol {
    var presenter: PresenterProtocol? {get set}
    func updateScreen()
}

protocol BarButtonViewDelegate {
    func startButtonPressed()
    func stopButtonPressed()
    func dropDBButtonPressed()
    func mapButtonPressed()
}

class LocationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationTableViewControllerProtocol, BarButtonViewDelegate {
    
    var presenter: PresenterProtocol?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        let barViewController = storyboard?.instantiateViewController(withIdentifier: "barButtonControllerID") as! BarButtonViewController
        self.addChildViewController(barViewController)
        barViewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(barViewController.view)
        barViewController.delegate = self
        barViewController.didMove(toParentViewController: self)
    }
    
    func updateScreen(){
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presenter?.numberOfRowAt(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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

    func startButtonPressed() {
        self.presenter?.startButtonPressed()
    }
    
    func stopButtonPressed() {
        self.presenter?.stopButtonPressed()
    }
    
    func dropDBButtonPressed() {
        self.presenter?.dropDBButtonPressed()
    }
    
    func mapButtonPressed() {
        self.presenter?.mapButtonPressed()
    }
    
    
}
