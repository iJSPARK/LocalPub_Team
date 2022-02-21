//
//  CallViewController.swift
//  MovieListQuiz
//
//  Created by Serang MacBook Pro 16 on 2022/02/01.
//

import UIKit
import MapKit

class CallViewController: UIViewController {
    
    var call: CallList?

    @IBOutlet var navCallTitle: UINavigationItem!
    
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var callNameLabel: UILabel!
    @IBOutlet var callDateLabel: UILabel!
    @IBOutlet var callTimeLabel: UILabel!
    @IBOutlet var callWantLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        guard let call = call else { return }
        
        let filePath = "/all/\(call.callUID!).jpg"
        drawUserImage( imgView: callImage, filePath: filePath )
        
        callNameLabel.text = call.callName
        
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        callDateLabel.text = "CallDate".localized() + ": \( dateform.string( from: call.callDate! ) )"
        
        callTimeLabel.text = "CallTime".localized() + ": \( call.callTime )"
      
        let gender = call.callGender == 0 ? "Female" : "Male"
        callWantLabel.text = "Want: " + ": \( gender ), \( call.callLanguage )"
        
        if let area = call.callArea {
            
            mapView.layer.cornerRadius = 20
            mapView.layer.borderWidth = 1
            mapView.layer.borderColor = UIColor.gray.cgColor
            
            mapView.isHidden = false
            
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()

            annotation.title = "\(area[0]), \(area[1])"
            annotation.subtitle = "\(area[0]), \(area[1])"

            //let coord = CLLocationCoordinate2D( latitude: 37.55769, longitude: 126.92450 )
            let coord = CLLocationCoordinate2D( latitude: area[0], longitude: area[1] )
            
            let pSpan = MKCoordinateSpan( latitudeDelta: 0.6, longitudeDelta: 0.6 )
            
            annotation.coordinate = coord

            let pRegion = MKCoordinateRegion( center: coord, span: pSpan )
            
            mapView.setRegion(pRegion, animated: true)
        
            mapView.addAnnotation(annotation)
            
        } else {
            
            mapView.isHidden = true
        }
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
//        self.performSegue(withIdentifier: "unwindToCallList", sender: self )
    }
    
}
