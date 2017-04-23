//
//  Location.swift
//  mapkittut
//
//  Created by Chris Mitchell on 4/14/17.
//  Copyright © 2017 Chris Mitchell. All rights reserved.
//

import Foundation

import Firebase
import FirebaseAuth

import MapKit


struct Location {
    
    let address: String
    let lat: String
    let lon: String
    let userid: String
    let locationid: String
   // let catagory: String
    let ranking: String
    let catag: String
    let namee: String
    
    let ref: FIRDatabaseReference?
    
  
    
    
    init(address: String, lat: String,  lon: String, userid: String, locationid: String, ranking: String, catag: String, namee: String) {
        
        self.address = address
        self.lat = lat
        self.lon = lon
        self.userid = userid
        self.ref = nil
        self.locationid = locationid
    
        self.ranking = ranking
       self.catag = catag
        self.namee = namee
    
    }
    
    
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        address = snapshotValue["address"] as! String
        lat = snapshotValue["lat"] as! String
        lon = snapshotValue["lon"] as! String
        userid = snapshotValue["userid"] as! String
        locationid = snapshotValue["locationid"] as! String
      //  catagory = snapshotValue["catagory"] as! String
        
        
        ranking = snapshotValue["ranking"] as! String
       catag = snapshotValue["catag"] as! String
        
        namee = snapshotValue["name"] as! String
        
        ref = snapshot.ref
        
        
        
        
    }
    
    func toAnyObject() -> Any {
        return [
            "address": address,
            "lat": lat,
            "lon": lon,
            "userid": userid
            
        ]
    }
    
}


