//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by doortje on 03/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    //
    var orderMinutes = 0
    var menuItems = [MenuItem]()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Reload de data zodat de juiste order wordt laten zien in de table view. 
        NotificationCenter.default.addObserver(tableView, selector:
            #selector(UITableView.reloadData), name:
            MenuController.orderUpdatedNotification, object: nil)
        
    }

    // Als dit 0 is, is ordertable leeg. 
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // Returnt het aantal items dat is gekozen.
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    
    // Configureert de cellen.    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    

    func configure(_ cell: UITableViewCell, forItemAt indexPath:
        IndexPath) {
        // Haalt de informatie op over de gerechten om in de cell te plaatsen, zoals de titel van het gerecht.
        let menuItem =
            MenuController.shared.order.menuItems[indexPath.row]
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
    
    // Hoogte van de plaatjes.
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 100
    }


    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    //  Support het editen van de order (verwijderen van een gerecht).
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at:
                indexPath.row)
        }
    }
    
    // Als de dismiss button op OrderConfirmationViewController is ingedrukt, verwijdert hij de order uit de lijst in de OrderTableViewController.
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    
    // Als de submit button wordt ingedrukt telt hij de prijs bij elkaar op. Vervolgens laat hij een bericht zien die je moet bevestigen of kan annuleren.
    @IBAction func submitTapped(_ sender: Any) {
        let orderTotal =
            MenuController.shared.order.menuItems.reduce(0.0)
            { (result, menuItem) -> Double in
                return result + menuItem.price
        }
        let formattedOrder = String(format: "$%.2f", orderTotal)
        // Bericht (alert) voor gebruiker:
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of\(formattedOrder)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in self.uploadOrder()
            })
            alert.addAction(UIAlertAction(title: "Cancel",
            style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
    }
    
    // Checkt of de server het aantal minuten ophaalt en geeft die mee in de Segue als je de order upload.
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map
        { $0.id }
        // Roept submitOrder uit de MenuController aan.
        MenuController.shared.submitOrder(forMenuIDs: menuIds)
        { (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier:
                        "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    // Geeft informatie door aan OrderConformationViewController. Order + aantal minuten. 
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController = segue.destination
                as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
        }
    }

}
