//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by doortje on 03/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var priceLabel: UILabel!
        @IBOutlet weak var detailTextLabel: UILabel!
        @IBOutlet weak var addToOrderButton: UIButton!

    // Property dat informatie over MenuItem bevat.
    var menuItem: MenuItem!

    // Radius en Update UI.
    override func viewDidLoad() {
        super.viewDidLoad()
        addToOrderButton.layer.cornerRadius = 5.0
        updateUI()
        }
    
   
        func updateUI() {
            
             // Update de labels om ze te matchen met de labels uit MenuItem.
            titleLabel.text = menuItem.name
            priceLabel.text = String(format: "$%.2f", menuItem.price)
            detailTextLabel.text = menuItem.detailText
            // Haalt de plaatjes van het eten op.
            MenuController.shared.fetchImage(url: menuItem.imageURL)
            { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }

    @IBAction func orderButtonTapped(_ sender: UIButton) {
        // Code van de animatie die verschijnt als je op de Order button klikt.
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform =
                CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToOrderButton.transform =
                CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        // Geeft informatie van menuItems door naar MenuController, zodat deze het door kan geven aan OrderTableViewController.
        MenuController.shared.order.menuItems.append(menuItem)
    }
    


}


