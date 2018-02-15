//
//  AddMapViewController.swift
//  Pagina
//
//  Created by user on 2/12/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class AddMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    @IBOutlet weak var addLocationMapView: MKMapView!
    
    @IBAction func saveLocationNavbarButton(_ sender: Any) {
        if let user = Auth.auth().currentUser{
            let ref = Database.database().reference();
        ref.child("users").child(user.uid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).child("inspirations").childByAutoId().updateChildValues(["type" : "map", "lat" : currentLocation.coordinate.latitude, "long": currentLocation.coordinate.longitude]);
            navigationController?.popViewController(animated: true)
        }
    
    }
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    var locationManager:CLLocationManager!;
    var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationMapView.showsUserLocation = true
        
        findMyLocation();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MAP
    func findMyLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0] as CLLocation
        let distance = currentLocation.distance(from: newLocation)
        if distance > 100 {
            currentLocation = newLocation;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

}
