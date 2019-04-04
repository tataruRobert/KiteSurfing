//
//  TableViewController.swift
//  KiteSurfing
//
//  Created by Tataru Robert on 26/03/2019.
//  Copyright © 2019 Tataru Robert. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var locations : [Location] = []
    var windProb : String = ""
    var country : String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI(windProb, country)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Location.start()
       updateUI(windProb,country)
        
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func UnwindToList(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? ConfigureViewController {
            windProb = sourceViewController.windProb
            country = sourceViewController.countryPicked
            print(self.country)
            updateUI(windProb, country)
        }
    }
    func updateUI(_ windProb : String,_ country : String) {
        Location.getAll(wind: self.windProb, country: self.country) { (results : [Location]) in
            self.locations = results
//            for location in self.locations {
//                //print(location)
//            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let add = addAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [add])
    }
    func addAction(at indexPath: IndexPath) -> UIContextualAction {
        
        
        if self.locations[indexPath.row].isFavorite {
            let remove = UIContextualAction(style: .normal, title: "Remove") { (action, view, completion) in
                Location.removeFavorite(spotId: self.locations[indexPath.row].id)
                self.updateUI(self.windProb, self.country)
                completion(true)
            }
            remove.backgroundColor = .red
            return remove
        } else {
            let add = UIContextualAction(style: .normal, title: "Add") { (action, view, completion) in
                Location.addFavorite(spotId: self.locations[indexPath.row].id)
                self.updateUI(self.windProb, self.country)
                completion(true)
            }
            add.backgroundColor = .blue
            return add
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let locationObject = locations[indexPath.row]
        cell.textLabel?.text = locationObject.name
        //print(locationObject.name)
        cell.detailTextLabel?.text = locationObject.country
        if locations[indexPath.row].isFavorite {
            cell.imageView?.image = UIImage(named: "star-on")
        } else {
             cell.imageView?.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = locations[indexPath.row]
        performSegue(withIdentifier: "DetailsSegue", sender: detail)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegue" {
            let detailsViewController = segue.destination as!
            DetailsViewController
                detailsViewController.details = sender as? Location

        }
    }
 

}
