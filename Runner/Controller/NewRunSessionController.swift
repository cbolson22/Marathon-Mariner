//
//  NewRunSessionController.swift
//  Runner
//
//  Created by Connor Olson on 7/26/23.
//

import UIKit
import MapKit
//import CoreLocation


class NewRunSessionController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    

    var name = "New Run"
    
    var miles = 0.0
    
    let date = Date()
    
    
    //timer
    var timer: Timer? = Timer()
    
    var hours: Int16 = 0
    var minutes: Int16 = 0
    var seconds: Int16 = 0
    var timeString: String = "0:00:00"
    
    
    ///FOR MAP!!*!*!***!*!*!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation!
    
    struct coord {
        var latitude: Double
        var longitude: Double
    }
    
    var coordinates = [coord]() 
    
    
    class MapPin : NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        let num: Int

        init(coordinate: CLLocationCoordinate2D, num: Int) {
            self.coordinate = coordinate
            self.num = num
        }
    }
    
    
    var curLocationFollowed = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///FOR MAP!!*!*!***!*!*!
        //////FOR MAP!!*!*!***!*!*!
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            
            //CHANGE FOR CLOSER PINS (ORIGIONALLY 10)
            locationManager.distanceFilter = 5
            
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            mapView.delegate = self
        }
        
        
        //timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
        dateLabel.text = "Date: \(date.formatted())"
        
      
        refreshName()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    
    func refreshName() {
        name = "\(date.formatted())     T: \(timeString)     M: \(String(format: "%.2f", miles))"
    }
    
    
    //TIMER
    @objc func timerCounter() {
        // Decrement the countdown duration
        if seconds == 59 {
            seconds = 0
            minutes += 1
            if minutes == 60 {
                minutes = 0
                hours += 1
            }
        } else {
                seconds += 1
        }
        
        var text = "\(hours):"
        
        if minutes / 10 == 0 {
            text.append("0\(minutes):")
        } else {
            text.append("\(minutes):")
        }
        
        if seconds / 10 == 0 {
            text.append("0\(seconds)")
        } else {
            text.append("\(seconds)")
        }
        
        timeString = text
        
        timeLabel.text = "Time: \(timeString)"
        
        refreshName()
        
    }
    
    func stopTimer() {
        // Stop the timer

        timer?.invalidate()
        timer = nil
    }
    
    
    ///FOR MAP!!*!*!***!*!*!
    //////FOR MAP!!*!*!***!*!*!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        
        let lat = (locations.last?.coordinate.latitude)!
        let lon = (locations.last?.coordinate.longitude)!
        
        
//        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//
//        //last coord
//        if lastLocation != nil{
//            points.append(CLLocationCoordinate2D(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude))
//
//            //new coord
//            points.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
//
//
//            let polyline = MKPolyline(coordinates: points, count: points.count)
//            mapView.addOverlay(polyline)
//        }
        
        if lastLocation == nil {
            lastLocation = locations.last
        } else if let location = locations.last {
            let metersToMilesConversionFactor: Double = 0.000621371 // 1 meter ≈ 0.000621371 miles
            let distanceInMiles = lastLocation.distance(from: location) * metersToMilesConversionFactor
            miles += distanceInMiles
            milesLabel.text = String(format: "%.2f", miles)
            
            
            var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            
            points.append(CLLocationCoordinate2D(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude))
            
            //new coord
            points.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
            
            let polyline = MKPolyline(coordinates: points, count: points.count)
            mapView.addOverlay(polyline)
        }
 

        coordinates.append(coord(latitude: lat, longitude: lon))
        
        lastLocation = locations.last
        
        
//        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//
        ////**********************
        ///CHANGE***** ONLY NEED TO MAKE POLYLINE BETWEEN LAST TWO POINTS BC RIGHT NOW GOING OVER LINE MANY TIMES
        ////**********************
        ///
//        for coord in coordinates {
//            points.append(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
//        }
//
//        let polyline = MKPolyline(coordinates: points, count: points.count)
//        mapView.addOverlay(polyline)
        
        if curLocationFollowed {
            zoomToRegion()
        }
        
        refreshName()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polylineRenderer = MKPolylineRenderer(polyline: polyline)
                polylineRenderer.strokeColor = UIColor.blue
                polylineRenderer.lineWidth = 5
                return polylineRenderer
            }
            return MKOverlayRenderer()
        }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }

    
    @IBAction func locationButtonPresed(_ sender: UIButton) {
        curLocationFollowed = true
        zoomToRegion()
    }
    
    
    //MARK:- Zoom to region

    func zoomToRegion() {

        //print(coordinates)

        let location = CLLocationCoordinate2D(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude)

        let region = MKCoordinateRegion(center: location, latitudinalMeters: 300.0, longitudinalMeters: 450.0)

        mapView.setRegion(region, animated: true)
    }

}
