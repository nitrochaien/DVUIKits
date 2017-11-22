//
//  MapController.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 1/24/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit
import MapKit

let kDefaultSpanLevel = 0.01

class MapController: UIViewController
{
    @IBOutlet var mMapView: MKMapView!
    @IBOutlet var mSearchBar: UISearchBar!
    @IBOutlet var mTableView: UITableView!
    
    let locationManager = CLLocationManager()
    let mReuseIdentifier = "MapCell"
    var mMapItems = [MKMapItem]()
    let mMaxTableViewHeight = UIScreen.main.bounds.height/3
    var mHeightOfRows:CGFloat = 0
    var mSelectedPin:CLPlacemark!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupMapView()
        initTableView()
        initSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetView(false)
    }
    
    func setupMapView() {
        locationManager.delegate = self
        //set accuracy to best
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //user only see the location permission dialog once
        locationManager.requestWhenInUseAuthorization()
        //get current location
        if #available(iOS 9.0, *)
        {
            locationManager.requestLocation()
        }
        else
        {
            // Fallback on earlier versions
            locationManager.startUpdatingLocation()
        }
        
        addTrackUserLocationButton()
        addMapTapGesture()
    }
    
    func addTrackUserLocationButton() {
//        let buttonItem = MKUserTrackingBarButtonItem(mapView: mMapView)
//        navigationItem.leftBarButtonItem = buttonItem
        
        if #available(iOS 11.0, *) {
            let buttonTrack = MKUserTrackingButton(mapView: mMapView)
            buttonTrack.translatesAutoresizingMaskIntoConstraints = false
            buttonTrack.backgroundColor = .white
            buttonTrack.layer.shadowOpacity = 0.3
            buttonTrack.layer.shadowRadius = 10
            buttonTrack.layer.cornerRadius = 3 //magical number lmao
            
            mMapView.addSubview(buttonTrack)
            
            mMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[buttonTrack]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: ["buttonTrack" : buttonTrack]))
            mMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[buttonTrack]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: ["buttonTrack" : buttonTrack]))
        } else {
            // Fallback on earlier versions
        }
    }
    
    func addMapTapGesture() {
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.2
        longPressGesture.addTarget(self, action: #selector(onMarkLocation))
        mMapView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func onMarkLocation(_ gesture: UIGestureRecognizer) {
        if gesture.state != .began { return }
        
        let touchPoint = gesture.location(in: mMapView)
        let location = mMapView.convert(touchPoint, toCoordinateFrom: mMapView)
        let placemark = MKPlacemark(coordinate: location)
        dropPinZoomIn(placemark: placemark)
    }
    
    func addBottomSheetView(_ scrollable: Bool = true) {
        let bottomSheetVC = scrollable ? ScrollableBottomSheetViewController() : BottomSheetViewController()
        
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    func updateTableView()
    {
        var height = mTableView.rowHeight;
        height *= CGFloat(mMapItems.count);
        
        if height > mMaxTableViewHeight
        {
            height = mMaxTableViewHeight
        }
        var tableFrame = mTableView.frame
        tableFrame.size.height = height
        mTableView.frame = tableFrame
        mTableView.setNeedsDisplay()
        
        mTableView.reloadData()
    }
    
    func resetTableView()
    {
        mSearchBar.text = ""
        mMapItems.removeAll()
        updateTableView()
    }
    
    func dropPinZoomIn(placemark: CLPlacemark)
    {
        // cache the pin
        mSelectedPin = placemark
        // clear existing pins
        mMapView.removeAnnotations(mMapView.annotations)
        
        guard let location = placemark.location else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mMapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(kDefaultSpanLevel, kDefaultSpanLevel)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mMapView.setRegion(region, animated: true)
    }
}

extension MapController: CLLocationManagerDelegate
{
    /*
     Called when the user responds to the permission dialog.
     If the user chose Allow, the status becomes CLAuthorizationStatus.AuthorizedWhenInUse.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            //trigger another requestLocation() in case the first one would have suffered a permission failure
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            print("Location: \(location)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mMapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error: \(error)")
    }
}

extension MapController: UITableViewDelegate, UITableViewDataSource
{
    //MARK: TableView
    func initTableView()
    {
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.estimatedRowHeight = 60
        mTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        mTableView.layer.borderColor = UIColor.lightGray.cgColor
        mTableView.layer.borderWidth = 1
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String
    {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.subThoroughfare != nil)
            && (selectedItem.subAdministrativeArea != nil  || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: mReuseIdentifier)
        
        let location = mMapItems[indexPath.row]
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: location.placemark)
        mHeightOfRows += cell.bounds.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mMapItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let location = mMapItems[indexPath.row]
        dropPinZoomIn(placemark: location.placemark)
        resetTableView()
    }
}

extension MapController: UISearchBarDelegate
{
    func initSearchBar()
    {
        mSearchBar.placeholder = "Search for places"
        mSearchBar.delegate = self
        
        mSearchBar.layer.borderWidth = 1
        mSearchBar.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard !searchText.isEmpty else {
            resetTableView()
            return
        }
        
        guard let mapView = mMapView,
            let searchBarText = mSearchBar.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard error == nil else {
                print("Error: \(error.debugDescription)")
                return
            }
            
            guard response == nil else {
                self.mMapItems = (response?.mapItems)!
                self.updateTableView()
                return
            }
        }
    }
}
