//
//  AddressPickerPage.swift
//  TALABAT
//
//  Created by Baby on 08.12.2020.
//

import UIKit
import AVFoundation
import GoogleMaps
import MapKit


class AddressPickerPage : UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var NextBtn: UIButton!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var locationLink : String!
    

    private let locationManager = CLLocationManager()
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    var searchResults = [MKLocalSearchCompletion]()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        skipBtn.layer.cornerRadius = 10

        locationManager.requestWhenInUseAuthorization()
        
        //Set up the delgates & the dataSources of both the searchbar & searchResultsTableView
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
        
        self.NextBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])
    }

    @IBAction func ToPayAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "MapToPay", sender: self)
    }
    @IBAction func skipAction(_ sender: Any)
    {
        SharedManager.shared.locationLinkFinal = ""
        self.performSegue(withIdentifier: "MapToPay", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
        if (searchResultsTable.contentSize.height >= 300) {
            tableViewHeightConstraint.constant = 300
        }
        else {
            tableViewHeightConstraint.constant = searchResultsTable.contentSize.height
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {

        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let geocoder = GMSGeocoder()
        self.addressLabel.unlock()
        locationLink = "http://www.google.com/maps/place/\(coordinate.latitude),\(coordinate.longitude)"
        
        SharedManager.shared.locationLinkFinal = locationLink

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
              return
            }
            self.addressLabel.text = lines.joined(separator: "\n")
        }
    }
}

extension AddressPickerPage: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
}

extension AddressPickerPage: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocodeCoordinate(position.target)
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
    }

}
// Setting up extensions for the table view
extension AddressPickerPage: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // Completer has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method delcares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        
        //Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension AddressPickerPage: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [self] (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            print(name)
            searchBar.searchTextField.text = ""
            
            let searchResult = searchResults[indexPath.row]
            addressLabel.text = searchResult.title + searchResult.subtitle
            
            tableViewHeightConstraint.constant = 0
            
            _ = coordinate.latitude
            _ = coordinate.longitude
            
            reverseGeocodeCoordinate(coordinate)
            mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
//            print(lat)
//            print(lon)
//            locationLink = "http://www.google.com/maps/place/\(lat),\(lon)"
//            print(locationLink!)
            
        }
    }
}
extension AddressPickerPage: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }

}



