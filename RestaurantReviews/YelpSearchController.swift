//
//  YelpSearchControllerViewController.swift
//  RestaurantReviews
//
//  Created by Jeff Ripke on 7/31/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import UIKit

class YelpSearchController: UIViewController {
    
    // MARK: - Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = YelpSearchResultsDataSource()
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, permissionsDelagate: nil)
    }()
    
    var coordinate: Coordinate?
    
    var isAuthorized: Bool {
        let isAuthorizedWithYelpToken = YelpAccount.isAuthorized
        let isAuthorizedForLocation = LocationManager.isAuthorized
        return isAuthorizedWithYelpToken && isAuthorizedForLocation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkPermissions()
        }
    }
    
    // MARk: - Table View
    
    func setupTableView() {
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    // MARK: - Search
    
    func setupSearchBar() {
        self.navigationItem.titleView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    // MARK: - Permissions
    
    /// Checks (1) if the user is authenticated against the Yelp API and has an OAuth
    /// token and (2) if the user has authorized location access for whenInUse tracking.
    func checkPermissions() {
        let isAuthorizedWithToken = YelpAccount.isAuthorized
        let isAuthorizedForLocation = LocationManager.isAuthorized
        let permissionsController = PermissionsController(isAuthorizedForLocation: isAuthorizedForLocation, isAuthorizedWithToken: isAuthorizedWithToken)
        present(permissionsController, animated: true, completion:  nil)
    }
}

// MARK: - UITableViewDelegate

extension YelpSearchController: UITableViewDelegate {
    
}

// MARK: - Search Results

extension YelpSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        print("Search text: \(searchTerm)")
    }
}

extension YelpSearchController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusiness" {
            
        }
    }
}

// MARK: - Location Manager Delegate

extension YelpSearchController: LocationManagerDelegate {
    func obtainCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        print(coordinate)
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}
