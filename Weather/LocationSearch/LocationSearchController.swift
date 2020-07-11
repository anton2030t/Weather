//
//  LocationSearchController.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit
import MapKit

protocol ChangeLocationDelegate {
    func newLocationEntered(name: String)
}

class LocationSearchController: UIViewController {
    
    // MARK: - variables
    @IBOutlet weak var tableView: UITableView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var delegate: ChangeLocationDelegate?
    let debouncer = Debouncer(delay: 0.1)
    let adapter = Adapter<MKLocalSearchCompletion, LocationResultCell>()
    private let reachability = try? Reachability()
    
    // MARK: - outlets
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: Constants.Image.name.kVerticalCloseButton)?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(Self.dismissButtonTapped))
        
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        locationSearchBar.delegate = self
       
        setupTableView()
    }
    
    private func setupTableView() {
        adapter.cellHeight = 44.0
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.tableFooterView = UIView()
        
        adapter.configure = { item, cell in
            cell.textLabel?.text = "\(item.title), \(item.subtitle)"
        }
        
        adapter.select = { [weak self] item in
            self?.addBookmark(item)
        }
    }
    
    private func addBookmark(_ item: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = " \(item.title), \(item.subtitle)"
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            if error != nil {
                
            } else {
                guard let response = response else {
                    return
                }
                
                for location in response.mapItems {
                    self.delegate?.newLocationEntered(name: location.name ?? "")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func handle(_ items: [MKLocalSearchCompletion]?) {
        adapter.items = items ?? []
        tableView.reloadData()
    }
    
}

extension LocationSearchController: MKLocalSearchCompleterDelegate, UISearchBarDelegate {
    
    // MARK: UISearchBar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.schedule { [weak self] in
            self?.searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        locationSearchBar.endEditing(true)
        locationSearchBar.resignFirstResponder()
        return true
    }
    
    // MKLocalSearch
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResults = cleanSearchResults()
        handle(searchResults)
    }
    
    // MARK: misc methods
    func cleanSearchResults() -> [MKLocalSearchCompletion] {
        let digitsCharacterSet = NSCharacterSet.decimalDigits
        let filteredResults = searchCompleter.results.filter { result in
            if result.title.rangeOfCharacter(from: digitsCharacterSet) != nil {
                return false
            }
            
            if result.subtitle.rangeOfCharacter(from: digitsCharacterSet) != nil {
                return false
            }
            
            return true
        }
        return filteredResults
    }
}
