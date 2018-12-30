////
////  LocationController.swift
////  Lattice
////
////  Created by Eli Zhang on 12/27/18.
////  Copyright © 2018 Eli Zhang. All rights reserved.
////
//
//import UIKit
//
//class LocationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    var locationSearch: UISearchController!
//    var tableView: UITableView!
//    var matchingItems: [MKMapItem] = []
//    var mapView: MKMapView? = nil
//    
//    let locationReuseIdentifier = "locationReuseIdentifier"
//    let cellHeight: CGFloat = 80
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: locationReuseIdentifier, for: indexPath) as! LocationCell
//        cell.setNeedsUpdateConstraints()
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellHeight
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var userAtIndex: String
//        let userProfileViewController = SelectedUserViewController(netID: userAtIndex, isTutor: tutorTuteeSegment.selectedSegmentIndex == 0, course: self.course)
//        navigationController?.pushViewController(userProfileViewController, animated: true)
//    }
//    
//}
