//
//  ViewController.swift
//  mapkittut
//
//  Created by Chris Mitchell on 3/25/17.
//  Copyright © 2017 Chris Mitchell. All rights reserved.
//



import UIKit
import MapKit

import CoreLocation
import CoreData
import QuartzCore


import Firebase




protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}



class ViewController: UIViewController   {

   // let locationManager = CLLocationManager()
    
    
    var selectedPin:MKPlacemark? = nil
    
    
    
  
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("locations")
   
    
    
    var resultSearchController:UISearchController? = nil
    
    
var  latitude_loc = "yes"
var longitude_loc = "yes"
    
var address_loc = "yes"
    
    
    let locationManager = CLLocationManager()
    
    
    
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    var timer: Timer?
    
    var managedObjectContext: NSManagedObjectContext!
    
    var logoVisible = false
    
    
    
  
    var ref: FIRDatabaseReference!
    
    var refHandleL:  UInt!
    
    
    
    
    
    
    
    func updateLabels() {
        
        
        if let location = location {
            
            
            latitude_loc = String(format: "%.8f", location.coordinate.latitude)
           
            longitude_loc = String(format: "%.8f", location.coordinate.longitude)
            
            
            if let placemark = placemark {
                address_loc = string(from: placemark)
                
            } else if performingReverseGeocoding {
                address_loc = "Searching for Address..."
            } else if lastGeocodingError != nil {
                address_loc = "Error Finding Address"
            } else {
                address_loc = "No Address Found"
            }
            
            
            
            
            
            
            
            
            
        }
    }
    
    
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        
        line1.add(text: placemark.subThoroughfare)
        
        line1.add(text: placemark.thoroughfare, separatedBy: " ")
        
        
        var line2 = ""
        
        line2.add(text: placemark.locality)
        
        line2.add(text: placemark.administrativeArea, separatedBy: " ")
        
        line2.add(text: placemark.postalCode, separatedBy: " ")
        
        
        line1.add(text: line2, separatedBy: "\n")
        
        return line1
        
    }
    
    
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            timer = Timer.scheduledTimer(timeInterval: 60, target: self,
                                         selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    
    func didTimeOut() {
        print("*** Time out")
        
        if location == nil {
            stopLocationManager()
            
            lastLocationError = NSError(domain: "MyLocationsErrorDomain",
                                        code: 1, userInfo: nil)
            
            updateLabels()
            // configureGetButton()
            
            
        }
    }  
    
    
    
    
    
    @IBAction func getLocation(_ sender: AnyObject) {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
           startLocationManager()
    }
        
        
        
        updateLabels()
       
      
        
      
        
        
       self.performSegue(withIdentifier: "segueTest", sender: self)
        
        
        
    }
    
    
    
       
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "segueTest") {
            
         
            
            let DestViewController = segue.destination as! UINavigationController
            let svc = DestViewController.topViewController as! DetailTableViewController
            
            
           svc.lon  =  longitude_loc
            
            svc.lat = latitude_loc
            
        svc.addr = address_loc
            
            
        }
        
        
        
        
    }
    
    @IBAction func unwindSaveLocation(sender: UIStoryboardSegue, segue: UIStoryboardSegue) {
        
        if(segue.identifier == "unwindsavelocation"){
            
            
            
            if let sourceViewController = sender.source as? DetailTableViewController {
                let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
                
               
            
                
                
                
                
                let newChannelRef = channelRef.childByAutoId()
                
               let channelItem = [
                
                "address": (sourceViewController.addressTextField.text!),
                "lat": (sourceViewController.latitudeTextField.text!),
                "lon": (sourceViewController.longitudeTextField.text!),
                "catag":(sourceViewController.catagoryTextField.text!),
                "ranking":(sourceViewController.rankingTextField.text!),
                "name":(sourceViewController.nameTextField.text!),
                "locationid":(newChannelRef.key),
                "userid": (userID)               ]
                
                
                 newChannelRef.setValue(channelItem)
                
              
               
                
                
           
                
                
           }
            
            
            
            
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
             updateLabels()
       
        
        
    }
    
    
    
}



extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        
        
        
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        if location == nil ||
            location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            
            lastLocationError = nil
            location = newLocation
            updateLabels()
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
               
                
                
                
                
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            
            if !performingReverseGeocoding {
                print("*** Going to geocode")
                
                performingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    
                    print("*** Found placemarks: \(placemarks), error: \(error)")
                    
                    self.lastGeocodingError = error
                    if error == nil, let p = placemarks, !p.isEmpty {
                        
                        if self.placemark == nil {             // add this if block
                            print("FIRST TIME!")
                           
                            
                            
                        //    self.playSoundEffect()
                        
                        
                        
                        }
                        
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                })
            }
        } else if distance < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
                updateLabels()
                
                
             //   configureGetButton()
            
            
            
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
        
        
        
}



extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        
        
    
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            
            
            annotation.subtitle = "\(city) \(state)"
            
            
            
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}




extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
        button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
}


extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}






