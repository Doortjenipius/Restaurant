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
    
    // Property dat informatie over menuItem bevat.
    var menuItem: MenuItem?
    
    // Radius en Update UI.
    override func viewDidLoad() {
        super.viewDidLoad()
        addToOrderButton.layer.cornerRadius = 5.0
        updateUI()
    }
    
    
    func updateUI() {
        // menuItem wordt niet meer zomaar uitgepakt, omdat het ook nil kan zijn.
        guard let menuItem = menuItem else { return }
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
        // menuItem wordt niet meer zomaar uitgepakt, omdat het ook nil kan zijn.
        guard let menuItem = menuItem else { return }
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
    
    // Om de ViewController te restoren heb je een menuItemid nodig. 
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let menuItem = menuItem else { return }
        coder.encode(menuItem.id, forKey: "menuItemId")
    }
    
    // Decode de data uit de encodeRestorableState functie.
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        let menuItemID = Int(coder.decodeInt32(forKey:
            "menuItemId"))
        menuItem = MenuController.shared.item(withID: menuItemID)!
        updateUI()
    }
    
    
}


