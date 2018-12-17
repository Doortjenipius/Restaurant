//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by doortje on 03/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    // Wordt aangemaakt zodat de MenuItems kunnen worden opgehaald.
    var menuItems = [MenuItem]()
    // Category wordt opgeslagen als een string.
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ontvangt de notificatie. Weet wanneer data moet worden geupdate.
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name:
            MenuController.menuDataUpdatedNotification, object: nil)
        
        // Roept updateUI aan
        updateUI()
    }
    
    @objc func updateUI() {
        // Category wordt niet meer zomaar uitgepakt, omdat het ook nil kan zijn.
        guard let category = category else { return }
        // Titel wordt aangepast
        title = category.capitalized
        // menuItems wordt aan category gekoppeld.
        menuItems = MenuController.shared.items(forCategory:
            category) ?? []
        // Tabel wordt opnieuw geladen.
        self.tableView.reloadData()
    }
    
    
    // Aantal sections is gelijk aan het aantal menuItems.
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    // Configureert de cellen.
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "MenuCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath:
        IndexPath) {
        // Haalt de informatie op over de gerechten om in de cell te plaatsen, zoals de titel van het gerecht.
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f",
                                            menuItem.price)
        // Haalt informatie op over het plaatje van het gerecht.
        MenuController.shared.fetchImage(url: menuItem.imageURL)
        { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath =
                    self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
    
    
    // Geeft de naam van de MenuItems door naar MenuItemDetailViewController.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "MenuDetailSegue" {
            let menuItemDetailViewController = segue.destination
                as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }
    
    // Hoogte van de cell.
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Om de ViewController te restoren heb je category nodig.
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let category = category else { return }
        coder.encode(category, forKey: "category")
    }
    // Decode de data uit de encodeRestorableState functie. 
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        category = coder.decodeObject(forKey: "category") as? String
        updateUI()
    }
}
