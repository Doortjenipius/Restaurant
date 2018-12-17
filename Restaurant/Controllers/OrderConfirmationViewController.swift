//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by doortje on 05/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    // Code van het label die aangeeft hoe lang je order nog duurt.
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Radius van de button
        dismissButton.layer.cornerRadius = 5.0
        timeRemainingLabel.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes."
        
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


