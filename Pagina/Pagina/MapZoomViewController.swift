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

class MapZoomViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var zoomedMapView: MKMapView!
    
    var locationManager:CLLocationManager!;
    var currentLocationLong: Double = 0.0;
    var currentLocationLat: Double = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap(long: currentLocationLong, lat: currentLocationLat);
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
        
    }

}
