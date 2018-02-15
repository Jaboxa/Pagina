//
//  MapZoomViewController.swift
//  Pagina
//
//  Created by Alice Darner on 2018-02-14.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapZoomViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var zoomedMapView: MKMapView!
    
    var locationManager:CLLocationManager!;
    
    var currentInspiration: StoryEditViewController.Inspiration = StoryEditViewController.Inspiration();
    var currentChapter: ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap(long: currentInspiration.long, lat: currentInspiration.lat);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setMap(long: Double, lat: Double){
        let place = MKPointAnnotation();
        place.coordinate.longitude = long;
        place.coordinate.latitude = lat;
        zoomedMapView.addAnnotation(place);
        zoomedMapView.showAnnotations(zoomedMapView.annotations, animated: true);
        
    }
    
    @IBAction func deleteMap(_ sender: Any) {
        let ref:DatabaseReference = Database.database().reference();
        
        if let user = Auth.auth().currentUser {
            ref.child("users").child(user.uid).child("stories").child(self.currentChapter.storyid).child("chapters").child(self.currentChapter.id).child("inspirations").child(self.currentInspiration.id).removeValue();
            navigationController?.popViewController(animated: true);
        }
        
    }
    

}
