//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    let orderTableViewController = OrderTableViewController()
    
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true

        NotificationCenter.default.addObserver(self, selector: #selector(updateUI),
                                               name: MenuController.menuDataUpdateNotification, object: nil)
        updateUI()
        updateOrderBadge()
        
        /*MenuController.shared.fetchCategories {(categories) in
        if let categories = categories{
            print("+")
            self.updateUI(with: categories)
        }
        }*/
    }
    
   func updateOrderBadge(){
       let itemsCount = MenuController.shared.order.menuItems.count
       let badgeValue = itemsCount > 0 ? "\(itemsCount)": nil
    (tabBarController!.tabBar.items![1] as! UITabBarItem).badgeValue = badgeValue
   
   }
        
      @objc func updateUI(){
            categories = MenuController.shared.categories
            self.tableView.reloadData()
            
            /*DispatchQueue.main.async {
                self.categories = categories
                self.tableView.reloadData()
            }*/
        }
        
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue"{
            let menuTableViewController = segue.destination as? MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController?.category = categories[index]
        }
    }
        
    

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIdentifier", for: indexPath)
        
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let categoryString = categories[indexPath.row]
        cell.textLabel?.text = categoryString.capitalized
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
