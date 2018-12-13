//
//  MenuController.swift
//  Restaurant
//
//  Created by doortje on 03/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import Foundation
import UIKit

class MenuController {
    
// MenuController is shared, zodat hij data kan doorgeven aan meerdere view controllers.
    static let shared = MenuController()
    
// Variabelen om Menu data van de server te gebruiken. (Local copies).
    private var itemsByID = [Int:MenuItem]()
    private var itemsByCategory = [String:[MenuItem]]()
    
// Base URL voor alle requests.
    let baseURL = URL(string: "https://resto.mprog.nl/")!
    var order = Order() {
// Update je order
        didSet {
            NotificationCenter.default.post(name:
                MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    
// Post request voor het maken van de order bevat de parameters voor de Menu IDs en haalt op hoeveel minuten een gerecht duurt om te bereiden.
    func submitOrder(forMenuIDs menuIds: [Int], completion:
        @escaping (Int?) -> Void) {
// URL voor order.
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
// Default type van GET naar POST.
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
// POST data is opgeslagen in de request.
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try?
                jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
//Stuurt het request.
        task.resume()
    }
    
// Update de order notificatie button.
    static let orderUpdatedNotification =
        Notification.Name("MenuController.orderUpdated")
    
// Request om plaatjes op te halen vanuit de server.
    func fetchImage(url: URL, completion: @escaping (UIImage?) ->
        Void) {
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            
            //checkt het plaatje. 
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
// Stuurt het request.
        task.resume()
    }


// Laadt het order lokaal.
    func loadOrder() {
        let documentsDirectoryURL =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let orderFileURL =
        documentsDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: orderFileURL) else
        { return }
        order = (try? JSONDecoder().decode(Order.self, from:
            data)) ?? Order(menuItems: [])
    }
    
// Slaat het order lokaal op.
    func saveOrder() {
        let documentsDirectoryURL =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let orderFileURL =
        documentsDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
    
        if let data = try? JSONEncoder().encode(order) {
            try? data.write(to: orderFileURL)
        }
    }
// Ophalen van data.
    func item(withID itemID: Int) -> MenuItem? {
        return itemsByID[itemID]
    }
    
    func items(forCategory category: String) -> [MenuItem]? {
        return itemsByCategory[category]
    }

    var categories: [String] {
        get {
            return itemsByCategory.keys.sorted()
        }
    }
// Stuurt een notificatie als de data is geupdate.
    static let menuDataUpdatedNotification =
        Notification.Name("MenuController.menuDataUpdated")
    
// Haalt categories op van de server zodra de app wordt gelaunchd.
    private func process(_ items: [MenuItem]) {
        itemsByID.removeAll()
        itemsByCategory.removeAll()
        
        for item in items {
            itemsByID[item.id] = item
            itemsByCategory[item.category, default: []].append(item)
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name:
                MenuController.menuDataUpdatedNotification, object: nil)
        }
    }

// Haalt Menu op van de server zodra de app wordt gelaunchd.
    func loadRemoteData() {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        let components = URLComponents(url: initialMenuURL,
                                       resolvingAgainstBaseURL: true)!
        let menuURL = components.url!
        
        let task = URLSession.shared.dataTask(with: menuURL)
        { (data, _, _) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try?
                    jsonDecoder.decode(MenuItems.self, from: data)
            {
                self.process(menuItems.items)
            }
        }
        
        task.resume()
    }
  
// Haalt menu items op van de server zodra de app wordt gelaunchd.
    func loadItems() {
        let documentsDirectoryURL =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let menuItemsFileURL =
    documentsDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: menuItemsFileURL)
            else { return }
        let items = (try? JSONDecoder().decode([MenuItem].self,
                                               from: data)) ?? []
        process(items)
    }
    
// Slaat de items op.
    func saveItems() {
        let documentsDirectoryURL =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let menuItemsFileURL =
    documentsDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")

        let items = Array(itemsByID.values)
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: menuItemsFileURL)
        }
    }
    


}
