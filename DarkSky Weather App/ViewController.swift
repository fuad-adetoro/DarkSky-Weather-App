//
//  ViewController.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 11/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Mark: Refresh and Activity elements
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    // Mark: CollectionView element
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Mark: Refresh button action
    @IBAction func refreshClicked(_ sender: Any) {
        hideRefreshButton()
        fetchWeather()
    }
    
    // Mark: HomeWeatherDisplayCell Nib file owner object
    let homeWeatherDisplayCellNib = Bundle.main.loadNibNamed("HomeWeatherDisplayViewCell", owner: HomeWeatherDisplayViewCell.self, options: nil)! as NSArray
    
    let cellId = "HomeWeatherDisplayViewCell"
    
    // Mark: Model Variables
    let weatherManager = WeatherManager()
    let locationManager = LocationManager()
    
    // Mark: Locations and CurrentWeatherViewModel array
    var locations: [Location] = []
    var currentWeatherViewModels: [CurrentWeatherViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DarkSkyAPI.apiKey.isEmpty {
            fatalError("Please include your API key")
        }
        
        configureCollectionView()
        createLocations()
    }
    
    func createLocations() {
        self.locations = locationManager.createLocations()
        
        fetchWeather()
    }
    
    func fetchWeather() {
        currentWeatherViewModels = []
        
        disableCollectionView()
        startActivityIndicator()
        
        weatherManager.fetchWeather(with: self.locations) { (currentWeatherViewModels, error) in
            self.stopActivityIndicator()
            
            self.currentWeatherViewModels = currentWeatherViewModels
            
            if error != nil {
                self.disableCollectionView()
                self.showRefreshButton()
                
                self.displayAlertWith(title: "Error Occurred!", message: "Sorry, an error occured!")
                return
            } else {
                self.enableCollectionView()
                self.hideRefreshButton()
                
                self.collectionView.reloadData()
            }
        }
    }
    
    // Mark: Configurate CollectionView
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellNib = UINib(nibName: cellId, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: UI display methods
    
    func disableCollectionView() {
        collectionView.isHidden = true
        collectionView.isUserInteractionEnabled = false
    }
    
    func enableCollectionView() {
        collectionView.isHidden = false
        collectionView.isUserInteractionEnabled = true
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    func showRefreshButton() {
        refreshButton.isHidden = false
        refreshButton.isEnabled = true
    }
    
    func hideRefreshButton() {
        refreshButton.isHidden = true
        refreshButton.isEnabled = false
    }
}


// Mark: UICollectionView DataSource & Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWeatherViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeWeatherDisplayViewCell
        
        let currentWeatherViewModel = currentWeatherViewModels[indexPath.row]
        cell.configure(viewModel: currentWeatherViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let homeWeatherDisplayCellObject = homeWeatherDisplayCellNib.object(at: 0) as! HomeWeatherDisplayViewCell
        
        let currentWeatherViewModel = currentWeatherViewModels[indexPath.row]
        homeWeatherDisplayCellObject.configure(viewModel: currentWeatherViewModel)
        
        // Calculate CellHeight based on configured viewModel
        let cellHeight = homeWeatherDisplayCellObject.preferredLayoutSizeFittingSize(targetSize: CGSize(width: self.view.frame.width, height: 0)).height
        
        if cellHeight <= 0 {
            return CGSize(width: self.view.frame.width, height: 134)
        } else {
            return CGSize(width: self.view.frame.width, height: cellHeight)
        }
    }
}



