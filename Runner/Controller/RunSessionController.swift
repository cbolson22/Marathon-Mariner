//
//  RunSessionController.swift
//  Runner
//
//  Created by Connor Olson on 7/25/23.
//

import UIKit
import MapKit


class RunSessionController: UIViewController, MKMapViewDelegate {
    
    
    //var selectedRun : Run?
    var date: Date = Date()
    
    var hours: Int16 = 0
    var minutes: Int16 = 0
    var seconds: Int16 = 0
    var timeString: String = "0:00:00"
    
    var distance: Double = 0.00
 
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRun: Run? {
        didSet {
            loadRun()
        }
    }
    
    var coordArray = [Coordinate]()
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        mapView.delegate = self
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for coord in coordArray {
            points.append(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
        }
        
//        for index in stride(from: coordArray.count - 1, through: 0, by: -1) {
//            points.append(CLLocationCoordinate2D(latitude: coordArray[index].latitude, longitude: coordArray[index].longitude))
//        }
        
        let polyline = MKPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(polyline)
        
        zoomToRegion()
        
        
        dateLabel.text = "Date: \(date.formatted())"
        
        timeLabel.text = "Time: \(timeString)"
        timeLabel.text = "Time: \(timeString)"
        
        milesLabel.text = "\(distance)"
        
    }
    
    func loadRun() {
        
        let request = Coordinate.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        
        let runPredicate = NSPredicate(format: "parentRun.title MATCHES %@", selectedRun!.title!)
        
        request.predicate = runPredicate
        
        request.sortDescriptors = [sortDescriptor]
        
        do {
            coordArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
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
    
    
    //MARK:- Zoom to region
    
    func zoomToRegion() {
        
        //print(coordinates)
        
        let location = CLLocationCoordinate2D(latitude: coordArray.first!.latitude, longitude: coordArray.first!.longitude)

        let region = MKCoordinateRegion(center: location, latitudinalMeters: 500.0, longitudinalMeters: 700.0)

        mapView.setRegion(region, animated: true)
    }
    
    
}
