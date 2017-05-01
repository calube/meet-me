//
//  ViewController.swift
//  Meet Me
//
//  Created by Caleb Davis on 4/29/17.
//  Copyright © 2017 Caleb Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var distance: Double = 50.0

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: -IBActions
extension ViewController {
    
    @IBAction func distanceSliderValueChanged(_ sender: Any) {
        distance = Double(distanceSlider.value)
        distanceLabel.text = "\(Int(distance)) miles"
    }
    
    @IBAction func searchButton(_ sender: Any) {
        performSegue(withIdentifier: "showNearbyUsersViewController", sender: nil)
    }
}

// MARK: -Prepare Segues
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNearbyUsersViewController" {
            let vc = segue.destination as! NearbyUsersViewController
            vc.distance = distance
            vc.myLng = 0
            vc.myLng = 0
        }
    }
}
