//
//  UIViewController+displayAlertTitle.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 15/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
