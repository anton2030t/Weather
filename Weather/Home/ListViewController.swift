//
//  ListViewController.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let weatherService = WeatherDataService(networking: NetworkService())
    private let adapter = Adapter<WeatherInformationDTO, ListCell>()
    private var refreshControl = UIRefreshControl()
    private var emptyView = EmptyView()
    private var namesArray = [String]()
    let defaults = UserDefaults.standard
    private let reachablity = try? Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = TitleManager.book_marks.localized
        setupTableView()
        
        let array = defaults.object(forKey: Constants.Keys.UserDefaults.kSavedNameArray) as? [String]
        namesArray = array ?? []
        
        view.addSubview(emptyView)
        NSLayoutConstraint.pin(view: emptyView, toEdgesOf: view)
        emptyView.alpha = 0
        
        checkForData()
    }
    
    private func checkForData() {
        if reachablity?.isConnectedToNetwork ?? false {
            if namesArray.count > 0 {
                namesArray.forEach{ name in
                    loadData(with: name)
                }
            } else {
                setupEmptyView(text: TitleManager.no_data_found.localized, subText: TitleManager.pls_add_cities.localized)
                refreshControl.endRefreshing()
            }
        } else {
            adapter.items = []
            setupEmptyView(text: TitleManager.check_network.localized)
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    private func setupTableView() {
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        tableView.register(cellType: ListCell.self)
        
        tableView.layer.cornerRadius = 0
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        
        tableView.delegate = adapter
        tableView.dataSource = adapter
        
        adapter.configure = { [weak self] weather, cell in
            self?.configure(with: weather, cell: cell)
        }
        
        adapter.select = { [unowned self] weatherDTO in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.ViewController.kWeatherDetailViewController) as? WeatherDetailViewController else { return }
            vc.weatherDTO = weatherDTO
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isTranslucent = false
            nav.navigationBar.barTintColor = .systemBlue
            nav.navigationBar.tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
            
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        
        adapter.edit = { [unowned self] weatherDTO, indexPath in
            self.namesArray = self.namesArray.filter({$0 != weatherDTO.cityName})
            self.defaults.set(self.namesArray, forKey: Constants.Keys.UserDefaults.kSavedNameArray)
            self.adapter.items.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.setupEmptyView(text: TitleManager.no_data_found.localized, subText: TitleManager.pls_add_cities.localized)
        }
    }
    
    @objc private func refreshData() {
        checkForData()
    }
    
    private func configure(with weather: WeatherInformationDTO, cell: ListCell) {
        cell.cityNameLabel.text = weather.cityName
        
        cell.temperatureLabel.text = "\(ConversionWorker.convertToCelsius(weather.atmosphericInformation?.temperatureKelvin ?? 0.0)) \(Constants.Values.TemperatureUnit.kCelsius)"
        
        let weatherConditionSymbol = ConversionWorker.weatherConditionSymbol(
            fromWeatherCode: weather.weatherCondition?[0].identifier,
            isDayTime: ConversionWorker.isDayTime(for: weather.dayInformation, coordinates: weather.coordinates) ?? true
        )
        cell.weatherConditionLabel.text = weatherConditionSymbol
    }
    
    private func loadData(with cityName: String) {
        if reachablity?.isConnectedToNetwork ?? false {
            refreshControl.beginRefreshing()
            weatherService.fetchBookmarkedLocations(cityName, completion: { [weak self] result in
                switch result {
                case .success(let weather):
                    self?.handle(weather)
                    self?.refreshControl.endRefreshing()
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.refreshControl.endRefreshing()
                }
            })
        } else {
            setupEmptyView(text: TitleManager.check_network.localized)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Identifier.Segue.kShowLocationSearch {
            
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetViewController = destinationNavigationController.topViewController as! LocationSearchController
            targetViewController.delegate = self
            
        }
    }
    
    private func handle(_ weather: WeatherInformationDTO?) {
        guard let weather = weather else {
            setupEmptyView(text: TitleManager.no_data_found.localized, subText: TitleManager.pls_add_cities.localized)
            return
        }
        
        adapter.items.append(weather)
        adapter.items = adapter.items.filterDuplicate({$1.cityName})
        tableView.reloadData()
        setupEmptyView(text: TitleManager.no_data_found.localized, subText: TitleManager.pls_add_cities.localized)
    }
    
    func setupEmptyView(text: String = "", subText: String = "") {
        emptyView.titleLabel.text = text
        emptyView.subLabel.text = subText
        
        UIView.animate(withDuration: 0.25, animations: {
            self.emptyView.alpha = self.adapter.items.isEmpty ? 1 : 0
        })
    }
}

extension ListViewController: ChangeLocationDelegate {
    func newLocationEntered(name: String) {
        namesArray.append(name)
        defaults.set(namesArray, forKey: Constants.Keys.UserDefaults.kSavedNameArray)
        loadData(with: name)
    }
}
