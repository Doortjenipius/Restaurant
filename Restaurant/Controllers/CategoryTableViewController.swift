//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by doortje on 03/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

// categories is een lijst van strings.
    var categories = [String]()
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// Ontvangt de notificatie. Weet wanneer data moet worden geupdate. 
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name:
        MenuController.menuDataUpdatedNotification, object: nil)
// updateUI wordt aangeroepen.
        updateUI()
    }
    

    @objc func updateUI() {
// categories wordt aan de juiste categories gekoppeld
        categories = MenuController.shared.categories
// Tabel wordt opnieuwe geladen
        self.tableView.reloadData()
    }
    
// Alleen de sectie met categories wordt gereturnd.
    override func numberOfSections(in tableView: UITableView) -> Int {
// #warning Incomplete implementation, return the number of sections
        return 1
    }
    
// Aantal sections is gelijkt aan het aantal categories.
    override func tableView(_ tableView: UITableView,
                               numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

// Configureert de cellen.
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "CategoryCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    

    func configure(_ cell: UITableViewCell, forItemAt indexPath:
        IndexPath) {
        
// Naam van de categorie in het texlabel.
        let categoryString = categories[indexPath.row]
        cell.textLabel?.text = categoryString.capitalized
    }
    
// Geeft de naam van de categorie door naar MenuTableViewController.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "MenuSegue" {
            let menuTableViewController = segue.destination as!
            MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController.category = categories[index]
        }
    }
    
// Hoogte van de cell.
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 120
    }

    
}

