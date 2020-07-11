//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    var weatherDTO: WeatherInformationDTO?
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionSymbolLabel: UILabel!
    @IBOutlet weak var conditionNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var addLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: Constants.Image.name.kVerticalCloseButton),
            style: .plain,
            target: self,
            action: #selector(Self.dismissButtonTapped))
        
        addLabel.layer.cornerRadius = addLabel.layer.frame.height/2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        entryTextView.addGestureRecognizer(tap)
        
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    func setNavBar() {
        let navigationBar = navigationController!.navigationBar
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = UIColor.systemBlue
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func configure() {
        
        let isDayTime = ConversionWorker.isDayTime(for: weatherDTO?.dayInformation, coordinates: weatherDTO?.coordinates) ?? true
        conditionSymbolLabel.text = ConversionWorker.weatherConditionSymbol(
            fromWeatherCode: weatherDTO?.weatherCondition?[0].identifier,
          isDayTime: isDayTime
        )
        
        cityLabel.text = weatherDTO?.cityName
        
        if cityLabel.text == "Moscow" {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "moscow")!)
        }
        conditionNameLabel.text = weatherDTO?.weatherCondition?.first?.conditionName
        temperatureLabel.text = "\(ConversionWorker.convertToCelsius(weatherDTO?.atmosphericInformation?.temperatureKelvin ?? 0.0)) \(Constants.Values.TemperatureUnit.kCelsius)"
    }
    
    @objc private func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let addVC = storyboard?.instantiateViewController(withIdentifier: "AddEntryViewController") as? AddEntryViewController {
            addVC.updateTextView = { [weak self] in
                if !addVC.textView.text.isEmpty {
                    self?.entryTextView.text = addVC.textView.text
                    self?.addLabel.isHidden = true
                    self?.entryTextView.isHidden = false
                } else {
                    self?.entryTextView.isHidden = true
                    self?.addLabel.isHidden = false
                }
            }
            present(addVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        if let addVC = storyboard?.instantiateViewController(withIdentifier: "AddEntryViewController") as? AddEntryViewController {
            addVC.updateTextView = { [weak self] in
                if !addVC.textView.text.isEmpty {
                    self?.entryTextView.text = addVC.textView.text
                    self?.addLabel.isHidden = true
                    self?.entryTextView.isHidden = false
                } else {
                    self?.entryTextView.isHidden = true
                    self?.addLabel.isHidden = false
                }
            }
            present(addVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func get5DayForecast(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.ViewController.kForecastViewController) as? ForcastViewController else { return }
        vc.weatherDTO = self.weatherDTO
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
