//
//  HomeWeatherDisplayViewCell.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 10/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

class HomeWeatherDisplayViewCell: UICollectionViewCell {
    
    // Mark: Weather information UI Elements
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    
    
    // Configure cell with CurrentWeatherViewModel
    func configure(viewModel currentWeatherViewModel: CurrentWeatherViewModel) {
        locationLabel.text = "\(currentWeatherViewModel.location.name)"
        tempLabel.text = "\(currentWeatherViewModel.temperature)"
        humidityLabel.text = "\(currentWeatherViewModel.humidity)"
        chanceOfRainLabel.text = "\(currentWeatherViewModel.precipProbability)"
    }
    
    
    // Calculate the height Using Autolayout
    func preferredLayoutSizeFittingSize(targetSize: CGSize) -> CGSize {
        let originalFrame = self.frame
        
        var frame = self.frame
        frame.size = targetSize 
        self.frame = frame
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        // calling this tells the cell to figure out a size for it based on the current items set
        let computedHeight = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        let newSize = CGSize(width:self.frame.width, height: computedHeight)
        
        self.frame = originalFrame
        
        return newSize
    }
}
