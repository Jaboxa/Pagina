//
//  MapCollectionViewCell.swift
//  Pagina
//
//  Created by Alice Darner on 2018-02-14.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapInspirationCollectionViewCell: UICollectionViewCell, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBOutlet weak var inspirationMapView: MKMapView!
    
    func setMap(long: Double, lat: Double){
        let place = MKPointAnnotation();
        place.coordinate.longitude = long;
        place.coordinate.latitude = lat;
        inspirationMapView.addAnnotation(place);
        inspirationMapView.showAnnotations(inspirationMapView.annotations, animated: true);
    }
    
}
