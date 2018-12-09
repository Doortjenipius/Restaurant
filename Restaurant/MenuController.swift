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
    
    // Base URL voor alle requests.
    let baseURL = URL(string: "https://resto.mprog.nl/")!
    var order = Order() {
        // Update je order 
        didSet {
            NotificationCenter.default.post(name:
                MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    // Get request voor de categories.
    func fetchCategories(completion: @escaping ([String]?) -> Void)
    {
        // URL voor categories.
        let categoryURL =
            baseURL.appendingPathComponent("categories")
        // Task voor het ophalen van alle categories.
        let task = URLSession.shared.dataTask(with: categoryURL)
            { (data, response, error) in
            if let data = data,
                let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as?
                    [String:Any],
                let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        // Stuurt de request.
        task.resume()
    }
    
    // Get requests voor het menu. Parameters:  De categoryName en array van MenuItems.
    func fetchMenuItems(forCategory categoryName: String,
                        completion: @escaping ([MenuItem]?) -> Void) {
        // URL voor menu.
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL,
                                       resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category",
                                              value: categoryName)]
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        //Stuurt de request.
        task.resume()
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
        //Stuurt de request.
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
        // Stuurt de request.
        task.resume()
    }
}
