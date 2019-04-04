//
//  DetailsViewController.swift
//  KiteSurfing
//
//  Created by Tataru Robert on 03/04/2019.
//  Copyright © 2019 Tataru Robert. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    var details : Location?
    
    @IBOutlet weak var long: UILabel!
   
    
    @IBOutlet weak var mapDetails: MKMapView!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var star: UIBarButtonItem!
    @IBOutlet weak var windProb: UILabel!
    @IBOutlet weak var country: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = details!.name
        if details!.isFavorite {
            star.image = UIImage(named: "star-on")
        } else {
            star.image = UIImage(named: "star-off")
            
        }
       

        print(details!.id)
        SpotDetails.getDetails(spotId: details!.id) { (results : SpotDetails?) in
            
            guard let Spot = results else {
                return
            }
           
            DispatchQueue.main.async {
                self.setUI()
                self.long.text = String (Spot.longitude)
                let position = CLLocation(latitude: Spot.latitude , longitude: Spot.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Spot.latitude, longitude: Spot.longitude)
                annotation.title = "When to go : \n" + Spot.whenToGo
                self.mapDetails.addAnnotation(annotation)
                self.centerMapOnLocation(location: position)
                self.lat.text = String (Spot.latitude)
                self.windProb.text = String (Spot.windProbability) + "%"
            }
            
        }
        
       
        // Do any additional setup after loading the view.
    }
    
    let regionRadius: CLLocationDistance = 100_000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapDetails.setRegion(coordinateRegion, animated: true)
    }
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if details!.isFavorite {
            Location.removeFavorite(spotId: details!.id)
            star.image = UIImage(named: "star-off")
        } else {
            Location.addFavorite(spotId: details!.id)
            star.image = UIImage(named: "star-on")
            
        }
        
    }
    func setUI() {
        if let details = details {
            country.text = details.country
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
