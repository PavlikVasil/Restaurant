//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {

    static let orderTVC = OrderTableViewController()
    
    var menuItems = [MenuItem]()
    
    var orderMinutes: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* NotificationCenter.default.addObserver(tableView!, selector:
               #selector(UITableView.reloadData), name:
               MenuController.orderUpdatedNotification, object: nil) */
        
       /* NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
                  print("app did enter background")
            MenuController.shared.saveItems()
                  MenuController.shared.saveOrder()
              }*/
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuController.shared.order.menuItems.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderIdentifier", for: indexPath)

        configure(cell, forItemAt: indexPath)

        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath){
           let menuItem = MenuController.shared.order.menuItems[indexPath.row]
           cell.textLabel?.text = menuItem.name
           cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
       }
    
    func updateOrderBadge(){
        let itemsCount = MenuController.shared.order.menuItems.count
        let badgeValue = itemsCount > 0 ? "\(itemsCount)": nil
        navigationController?.tabBarItem.badgeValue = badgeValue
        navigationController?.viewControllers[0].tabBarItem.badgeValue = badgeValue
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
           tableView.reloadData()
            
            updateOrderBadge()
        }
}
    
   @IBAction func unwindToOrderList(segue: UIStoryboardSegue){
        if segue.identifier == "Dismiss"{
            menuItems.removeAll()
            tableView.reloadData()
            updateOrderBadge()
        }
    }
       
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        let formatOrder = String(format: "$%.2f", orderTotal)
        
        let alert = UIAlertController(title: "Confirm Order", message: "Price of your order - \(formatOrder)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            self.uploadOrder()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func uploadOrder(){
        let menuIDs = MenuController.shared.order.menuItems.map{$0.id}
        
        MenuController.shared.submitOrder(menuIds: menuIDs) { (minutes) in
            if let minutes = minutes{
                DispatchQueue.main.async {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            } else {print("Error")}
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue"{
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
        }
    }
     
    
}

extension OrderTableViewController: AddToOrderDelegate{
    func added(menuItem: MenuItem) {
        
        MenuController.shared.order.menuItems.append(menuItem)
        
        print(MenuController.shared.order.menuItems.count)
        let count = MenuController.shared.order.menuItems.count
        let indexPath = IndexPath(row: count-1, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        updateOrderBadge()
        //MenuController.shared.saveOrder()
        
    }
}
