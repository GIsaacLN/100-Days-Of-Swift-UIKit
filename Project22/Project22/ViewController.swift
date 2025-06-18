//
//  ViewController.swift
//  Project22
//
//  Created by Gustavo Isaac Lopez Nunez on 17/06/25.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    @IBOutlet var circle: UIView!
    var locationManager: CLLocationManager?
    var hasBeaconDetected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        circle.backgroundColor = .systemBackground
        circle.layer.cornerRadius = 128
        circle.layer.zPosition = -1
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let beacons = ["5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", "74278BDA-B644-4520-8F0C-720EAF059935"]
        
        for (i, beacon) in beacons.enumerated() {
            let uuid = UUID(uuidString: beacon)!
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon-\(i+1)")
                        
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        }
    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.distanceReading.text = "FAR"
                self.view.backgroundColor = .blue
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.distanceReading.text = "NEAR"
                self.view.backgroundColor = .orange
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.distanceReading.text = "RIGHT HERE"
                self.view.backgroundColor = .red
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
             default:
                self.beaconName.text = "UNKNOWN BEACON"
                self.distanceReading.text = "UNKNOWN"
                self.view.backgroundColor = .gray
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        guard let beacon = beacons.first else { return }
        if !hasBeaconDetected {
            hasBeaconDetected = true
            
            let ac = UIAlertController(title: "Beacon Detected", message: "A beacon has been detected for the first time", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
        beaconName.text = beacon.uuid.uuidString
        update(distance:  beacon.proximity)

    }
}

