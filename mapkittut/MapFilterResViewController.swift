//
//  MapFilterResViewController.swift
//  mapkittut
//
//  Created by Chris Mitchell on 4/8/17.
//  Copyright © 2017 Chris Mitchell. All rights reserved.
//



import UIKit
import MapKit



import Firebase
import FirebaseAuth






class MapFilterResViewController: UIViewController {

    var rank = "two"
    
    var cat = "two"
    
    
    let locationManager = CLLocationManager()
    
    
    var location: CLLocation?
    
    var selectedPin:MKPlacemark? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    
    
    
  
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("locations")
    
    
    // MARK: Properties
    var items: [Location] = []
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        FIRDatabase.database().reference().child("locations").observe(.value, with: {(snapshot) in
            
            
            var newItems: [Location] = []
            
            
            
            for item in snapshot.children {
                
                
                
                
                let locat = Location(snapshot: item as! FIRDataSnapshot)
                
                if( (locat.catag == self.cat) && (locat.ranking == self.rank)){
                    
                      newItems.append(locat)
                }
                    
        
                
              
                
                
                
            }
            
            
            
            self.items = newItems
            
            
            if(self.items.count > 0) {
                
            
            
            let ct = self.items.count // Add this line
            // Then changed the for statement from for _ in myData
            // To the line below and now all map points show up.
           
                for row in 0...ct-1 {
                let data: Location = self.items[row]
                
                
                let lat = data.lat
                
                //  lon = (data.valueForKey("longitude") as? String)!
                
                let lon = data.lon
                
                let latNumb = (lat as NSString).doubleValue
                let longNumb = (lon as NSString).doubleValue
                
               let cityadd =  CityLocation(title: data.address, coordinate: CLLocationCoordinate2D(latitude: latNumb, longitude: longNumb))
                
                
                
               
                
                
                self.mapView.addAnnotation( cityadd as MKAnnotation)
                
                
                
            }
            
            
            }
            
                     
            
            
            
            
        })
        
        
        
        
        
        
    }

    
    
    func fetch() {
        
        if(self.items.count > 0) {
            
            
            
       
               let ct = self.items.count // Add this line
       
            
            
        for row in 0...ct-1 {
            
            
            let data: Location = items[row]
            
            
            let lat = data.lat
            
        
            
             let lon = data.lon
             
            
            
            let latNumb = (lat as NSString).doubleValue
            let longNumb = (lon as NSString).doubleValue
            let signLocation = CLLocationCoordinate2DMake(latNumb, longNumb)
           
        
            
       
        self.mapView.addAnnotation(signLocation as! MKAnnotation)
            
            
            
        }
    
        
        
        
    }
    
    
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func cancel() {
        
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}









extension MapFilterResViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
      
             
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}





