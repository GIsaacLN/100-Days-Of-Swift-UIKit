//
//  ViewController.swift
//  Project16
//
//  Created by Gustavo Isaac Lopez Nunez on 28/05/25.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "map.fill"), style: .plain, target: self, action: #selector(chooseMapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.", urlExtension: "London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", urlExtension: "Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", urlExtension: "Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", urlExtension: "Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", urlExtension: "Washington,_D.C.")
        let mexico = Capital(title: "Mexico City", coordinate: CLLocationCoordinate2D(latitude: 19.433333, longitude: -99.133333), info: "Originally built on top of a lake.", urlExtension: "Mexico_City")
        mapView.addAnnotations([london, oslo, paris, rome, washington, mexico])
    }
    
    @objc func chooseMapType() {
        let ac = UIAlertController(title: "Map style", message: "Choose a map style", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: mapStyleSelected))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: mapStyleSelected))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: mapStyleSelected))
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: mapStyleSelected))
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: mapStyleSelected))
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default, handler: mapStyleSelected))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func mapStyleSelected(_ alertAction: UIAlertAction) {
        switch alertAction.title {
        case "Standard":
            mapView.mapType = .standard
        case "Satellite":
            mapView.mapType = .satellite
        case "Hybrid":
            mapView.mapType = .hybrid
        case "Satellite Flyover":
            mapView.mapType = .satelliteFlyover
        case "Hybrid Flyover":
            mapView.mapType = .hybridFlyover
        case "Muted Standard":
            mapView.mapType = .mutedStandard
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        let identifier = "capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = .systemCyan

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailWebVC") as? DetailViewController {
            vc.capital = capital
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

