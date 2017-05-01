//
//  NearbyUsersViewController.swift
//  Meet Me
//
//  Created by Caleb Davis on 4/30/17.
//  Copyright © 2017 Caleb Davis. All rights reserved.
//

import UIKit
import Firebase

struct User {
    let name: String
    let location: CLLocationCoordinate2D
    let distance: CLLocationDistance
    
    init(name: String,
         location: CLLocationCoordinate2D,
         distance: CLLocationDistance) {
        self.name = name
        self.distance = distance
        self.location = location
    }
}

class NearbyUsersViewController: UIViewController, CLLocationManagerDelegate {
    
    fileprivate let cellId = "cell"
    var distance: Double = 0.0
    var myLat: CLLocationDegrees = 34.171996
    var myLng: CLLocationDegrees = -118.348593
    
    var userArray: [User] = []
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.configure()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            fetchNearbyUsers(lat: myLat, lng: myLng)
        }
    }

}

//MARK: -UITableviewDelegate and Datasource
extension NearbyUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = userArray[indexPath.row]
        
        let test = String(format: "%.1f", user.distance)
        cell.textLabel?.text = "\(user.name)          \(test) miles"
        return cell
    }
    
}

// MARK: - FetchUsers
extension NearbyUsersViewController {
    
    func fetchNearbyUsers(lat: CLLocationDegrees, lng: CLLocationDegrees){
        
        let geofireRef = FIRDatabase.database().reference().child("test1")
        let geoFire  = GeoFire(firebaseRef: geofireRef)
        //geoFireRef is pointing to a firebase reference where I previously set all  places' location
        let userPosition = CLLocation(latitude:  34.171996, longitude: -118.348593)
        let circleQuery = geoFire?.query(at: userPosition, withRadius: distance)
        
        circleQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            print("Key '\(key!)' entered the search area and is at location '\(location!.coordinate)'")
            //getting distance of each Place return with the callBack
            let distanceFromUser = userPosition.distance(from: location)
            print(distanceFromUser)
            
            let user = User(name: key!, location: location.coordinate, distance: distanceFromUser * 0.000621371)
            self.userArray.append(user)
            self.userArray.sort(by: { (userA, userB) -> Bool in
                userA.distance < userB.distance
            })
            self.tableView.reloadData()
        })
        
    }
}
