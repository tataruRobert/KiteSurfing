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
        
    }
    @IBAction func UnwindToList(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? ConfigureViewController {
            windProb = sourceViewController.windProb
            country = sourceViewController.countryPicked
            updateUI(windProb, country)
        }
    }
    func updateUI(_ windProb : String,_ country : String) {
        Location.getAll(wind: self.windProb, country: self.country) { (results : [Location]) in
            self.locations = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let add = addAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [add])
    }
    
    
    func addAction(at indexPath: IndexPath) -> UIContextualAction {
        
        if self.locations[indexPath.row].isFavorite {
            let action = UIContextualAction(style: .normal, title: "Remove") { (action, view, completion) in
                Location.removeFavorite(spotId: self.locations[indexPath.row].id)
                self.updateUI(self.windProb, self.country)
                //self.locations[indexPath.row].isFavorite = false
                completion(true)
            }
            action.backgroundColor = .red
            self.locations[indexPath.row].isFavorite = false
            return action
        } else {
            let action = UIContextualAction(style: .normal, title: "Add") { (action, view, completion) in
                Location.addFavorite(spotId: self.locations[indexPath.row].id)
                self.updateUI(self.windProb, self.country)
                //self.locations[indexPath.row].isFavorite = true
                completion(true)
            }
            action.backgroundColor = .blue
            self.locations[indexPath.row].isFavorite = true
            return action
        }
       
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let locationObject = locations[indexPath.row]
        cell.textLabel?.text = locationObject.name
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegue" {
            let detailsViewController = segue.destination as!
            DetailsViewController
                detailsViewController.details = sender as? Location
        }
    }
 

}
