//
//  MenuController.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation
import UIKit

class MenuController{
    let baseUrl = URL(string: "http://localhost:8090/")!
    
    
    static let shared = MenuController()
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    var order = Order(){
        didSet{
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    private var itemsById = [Int: MenuItem]()
    private var itemsByCategory = [String: [MenuItem]]()
    
    func item(withId itemId: Int) -> MenuItem?{
        return itemsById[itemId]
    }
    
    func items(forCategory category: String) -> [MenuItem]?{
        return itemsByCategory[category]
    }
    
    var categories: [String]{
        get{
            return itemsByCategory.keys.sorted()
        }
    }
    
    static let menuDataUpdateNotification = Notification.Name("MenuController.menuDataUpdated")
    
    private func process(_ items: [MenuItem]){
        itemsById.removeAll()
        itemsByCategory.removeAll()
        
        for item in items{
            itemsById[item.id] = item
            itemsByCategory[item.category, default: []].append(item)
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: MenuController.menuDataUpdateNotification, object: nil)
        }
    }
        
        func loadRemoteData(){
            let initialMenuURL = baseUrl.appendingPathComponent("menu")
            let components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
            let menuURL = components.url!
            
            let task = URLSession.shared.dataTask(with: menuURL){
                (data,_,_) in
                let jsonDecoder = JSONDecoder()
                if let data = data,
                    let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data)
                {
                    self.process(menuItems.items)
                }
            }
            task.resume()
        }
        
        
        
        
    
    
    func fetchCategories(completion: @escaping ([String]?) -> Void){
        let categoryURL = baseUrl.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoryURL)
        {(data,response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let categories = try? jsonDecoder.decode(Categories.self, from: data){
                completion(categories.categories)
            } else {
                print("-")
                completion(nil)
            }
        }
        task.resume()
    }

    func fetcMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void){
        let initialMenuURL = baseUrl.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        let task = URLSession.shared.dataTask(with: menuURL){(data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data){
                completion(menuItems.items)
            } else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
           let orderURL = baseUrl.appendingPathComponent("order")
           
           var request = URLRequest(url: orderURL)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let data = ["menuIds": menuIds]
           let jsonEncoder = JSONEncoder()
           let jsonData = try? jsonEncoder.encode(data)
           request.httpBody = jsonData
           
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               let jsonDecoder = JSONDecoder()
               
               if let data = data,
                   let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                   completion(preparationTime.prepTime)
               } else {
                   completion(nil)
               }
           }
           
           task.resume()
       }
    
    func fetchImages(url: URL, completion: @escaping(UIImage?)-> Void){
        let task = URLSession.shared.dataTask(with: url){(data,response,erro) in
            if let data = data,
                let image = UIImage(data: data){
                completion(image)
            }else {
                completion(nil)
            }
        }
        task.resume()
    }
  
     
    func loadOrder(){
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let orderFileURL = documentDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: orderFileURL) else {return print("error")}
        order = (try? JSONDecoder().decode(Order.self, from: data)) ?? Order(menuItems: [])
    }
    
    func loadItems(){
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let menuItemFileURL = documentDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: menuItemFileURL) else {return print("error")}
        let items = (try? JSONDecoder().decode([MenuItem].self, from: data)) ?? []
        process(items)
        //print(items)
    }
    
    func saveOrder(){
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let orderFileURL = documentDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        if let data = try? JSONEncoder().encode(order){
            try? data.write(to: orderFileURL)
        }
        print(order)
    }
    
    func saveItems(){
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let menuItemFileURL = documentDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        let items = Array(itemsById.values)
        if let data = try? JSONEncoder().encode(items){
            try? data.write(to: menuItemFileURL)
        }
        //print(items)
        
    }
    
    























}
