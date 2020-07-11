//
//  ForecastViewController.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ForcastViewController: UIViewController {
    
    // MARK: - Variables
    var weatherDTO: WeatherInformationDTO?
    @IBOutlet weak var tableView: UITableView!
    private let weatherService = WeatherDataService(networking: NetworkService())
    private let viewModels = [ForecastViewModel]()
    private let adapter = Adapter<ForecastViewModel, ForecastDayTableViewCell>()
    private var emptyView = EmptyView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let reachablity = try? Reachability()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = weatherDTO?.cityName
        
        adapter.cellHeight = 90.0
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.layer.cornerRadius = 0
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        view.addSubview(emptyView)
        NSLayoutConstraint.pin(view: emptyView, toEdgesOf: view)
        emptyView.alpha = 0
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        getFiveDayForecaset(weatherDTO?.cityName ?? "")
        
        adapter.configure = { item, cell in
            cell.weatherConditionImageView.image = item.icon
            cell.weekdayLabel.text = item.weekday
            cell.weatherConditionLabel.text = item.weatherCondition
            cell.temperatureLabel.text = item.temperature
        }
    }
    
    // MARK: - API
    private func getFiveDayForecaset(_ cityName: String) {
        if reachablity?.isConnectedToNetwork ?? false {
            activityIndicator.startAnimating()
            weatherService.fetchFiveDayForecast(cityName, completion: { [weak self] result in
                switch result {
                case .success(let lists):
                    let viewModels = lists?.compactMap(ForecastViewModel.init)
                    self?.handle(viewModels ?? [])
                    self?.activityIndicator.stopAnimating()
                case .failure(let error):
                    print("Failed with error: \(error.localizedDescription)")
                    self?.activityIndicator.stopAnimating()
                }
            })
        } else {
            setupEmptyView(text: TitleManager.check_network.localized)
        }
    }
    
    private func handle(_ vm: [ForecastViewModel]) {
        let viewModels = vm.filterDuplicate{$1.weekday}
        adapter.items = viewModels
        tableView.reloadData()
        
        setupEmptyView(text: TitleManager.no_data_found.localized)
    }
    
    func setupEmptyView(text: String = "", subText: String = "") {
        emptyView.titleLabel.text = text
        emptyView.subLabel.text = subText
        
        UIView.animate(withDuration: 0.25, animations: {
            print(self.adapter.items)
            self.emptyView.alpha = self.adapter.items.isEmpty ? 1 : 0
        })
    }

}
