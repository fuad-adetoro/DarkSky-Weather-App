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
        fetchWeather()
    }
    
    // Mark: HomeWeatherDisplayCell nib file owner object
    let homeWeatherDisplayCellNib = Bundle.main.loadNibNamed("HomeWeatherDisplayViewCell", owner: HomeWeatherDisplayViewCell.self, options: nil) as! NSArray
    
    let cellId = "HomeWeatherDisplayViewCell"
    
    // Mark: Model Variables
    let client = DarkSkyAPIClient()
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLocations() {
        // Create Location London
        createLocation(with: Coordinate(latitude: 51.5239227, longitude: -0.0844997), name: "London")
        
        // Create Location Paris
        createLocation(with: Coordinate(latitude: 48.858612, longitude: 2.342251), name: "Paris")
        
        // Create Location New York
        createLocation(with: Coordinate(latitude: 40.783512, longitude: -73.820419), name: "New York")
        
        // Create Location Los Angeles
        createLocation(with: Coordinate(latitude: 34.036095, longitude: -118.248354), name: "Los Angeles")
        
        // Create Location Tokyo
        createLocation(with: Coordinate(latitude: 35.679955, longitude: 139.843587), name: "Tokyo")
        
        fetchWeather()
    }
    
    func createLocation(with coordinate: Coordinate, name: String) {
        let location = Location(name: name, coordinate: coordinate)
        
        var canAppend = true
        
        for loc in locations {
            if loc.name == location.name {
                canAppend = false
            }
        }
        
        if canAppend {
            locations.append(location)
        }
    }
    
    func fetchWeather() {
        // Resetting currentWeatherViewModels array everytime the function calls
        currentWeatherViewModels = []
        
        disableCollectionView()
        startActivityIndicator()
        
        var error: DarkSkyError!
        
        let dispatchGroup = DispatchGroup()
        
        for location in locations {
            dispatchGroup.enter()
            client.getCurrentWeather(at: location.coordinate, completionHandler: { (currentWeather, darkSkyError) in
                dispatchGroup.leave()
                
                guard let currentWeather = currentWeather else {
                    error = darkSkyError
                    return
                }
                
                
                let currentWeatherViewModel = CurrentWeatherViewModel(from: currentWeather, location: location)
                self.currentWeatherViewModels.append(currentWeatherViewModel)
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            self.stopActivityIndicator()
            
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
        
        // Calculate CellHeight based on passed viewModel
        let cellHeight = homeWeatherDisplayCellObject.preferredLayoutSizeFittingSize(targetSize: CGSize(width: self.view.frame.width, height: 0)).height
        
        if cellHeight <= 0 {
            return CGSize(width: self.view.frame.width, height: 134)
        } else {
            return CGSize(width: self.view.frame.width, height: cellHeight)
        }
    }
}

extension UIViewController {
    func displayAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

