//
//  MapViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate {
    
    private let locationManager = CLLocationManager()
    var advert: Advert!
    
    @IBOutlet weak var smarketMap: MKMapView!
    
     let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smarketMap.delegate = self
        
        let alertTitle1 = NSLocalizedString("Error", comment: "")
        let alertText1 = NSLocalizedString("No location found!", comment: "")
        

        if advert.location == "no location" {
            let alertController = UIAlertController(title: alertTitle1, message: alertText1, preferredStyle: .alert)
            //let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
                self.navigationController!.popViewController(animated: true)
            }
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        } else {
            showUsersMapLocation()
        }
        
        
        //print("Users location is: \(advert.location))")
        
//        let usersLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//        centerMapOnLocation(location: usersLocation)
        // Do any additional setup after loading the view.
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        smarketMap.setRegion(coordinateRegion, animated: true)
    }

//    func mapView(_: MKMapView, didUpdate userLocation: MKUserLocation) {
//
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//
//        let width = 50.0
//
//        let height = 50.0
//
//        //let region = MKCoordinateRegion(center: center, latitudinalMeters: width, longitudinalMeters: height)
//
//        smarketMap.setUserTrackingMode(.follow, animated: true)
//    }
    
 //MKLocalSearch
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func showUsersMapLocation() {
        
        let usersLocation = advert.location
        let annotation = MKPointAnnotation()
        self.locationManager.getLocation(forPlaceCalled: usersLocation!) { location in
            guard let location = location else { return }
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.smarketMap.setRegion(region, animated: true)
            annotation.coordinate = center
            self.smarketMap.addAnnotation(annotation)
        }
    
    }

    
    
    func initLocData(advert: Advert) {
       self.advert = advert
    }
    
}

extension CLLocationManager {
    
    
    func getLocation(forPlaceCalled name: String,
                     completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(location)
        }
    }

}
