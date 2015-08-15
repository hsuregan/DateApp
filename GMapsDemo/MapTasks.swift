//
//  MapTasks.swift
//  GMapsDemo
//
//  Created by Regan Hsu on 8/12/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import Foundation

class MapTasks: NSObject {
    
    override init() {
        super.init()
    }
    
    //URL used to request for geocoding
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    //store data of the 1st address that will be returned in the results
    var lookupAddressResults: Dictionary<NSObject, AnyObject>!
    
    var fetchedFormattedAddress: String!
    
    var fetchedAddressLongitude: Double!
    
    var fetchedAddressLatitude: Double!
    
    func geocodeAddress(address: String!, withCompletionHandler completionHandler: ((status: String, success: Bool) -> Void)){
        
        if let lookupAddress = address {
            var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
            geocodeURLString = geocodeURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let geocodeURL = NSURL(string: geocodeURLString)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let geocodingResultsData = NSData(contentsOfURL: geocodeURL!)
                
                var error: NSError?
                let dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(geocodingResultsData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! Dictionary<NSObject, AnyObject>
                
                if (error != nil) {
                    println(error)
                    completionHandler(status: "", success: false)
                } else {
                    let status = dictionary["status"] as! String
                    if status == "OK" {
                        let allResults = dictionary["results"] as! Array<Dictionary<NSObject, AnyObject>>
                        self.lookupAddressResults = allResults[0]
                        
                        // Keep the most important values.
                        self.fetchedFormattedAddress = self.lookupAddressResults["formatted_address"] as! String
                        let geometry = self.lookupAddressResults["geometry"] as! Dictionary<NSObject, AnyObject>
                        self.fetchedAddressLongitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue
                        self.fetchedAddressLatitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lat"] as! NSNumber).doubleValue
                        
                        completionHandler(status: status, success: true)
                    }
                    else {
                        completionHandler(status: status, success: false)
                    }
                }
                
            })
            
        }
        else {
            completionHandler(status: "No valid address.", success: false)
        }

        
    }
    
    
    
}
