//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var category: String?
    var menuItems = [MenuItem]()
    
    //let menuController = MenuController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
                
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI),
        name: MenuController.menuDataUpdateNotification, object: nil)
        
        updateUI()
        
       /* MenuController.shared.fetcMenuItems(forCategory: category) {(menuItems) in
            if let menuItems = menuItems{
                print("+")
                self.updateUI(with: menuItems)
            }
        } */
    }
    
    @objc func updateUI(){
        guard let category = category else {return}
        
        title = category.capitalized
        self.menuItems = MenuController.shared.items(forCategory: category) ?? []
        self.tableView.reloadData()
        /* DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }*/
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let category = category else { return }
        coder.encode(category, forKey: "category")
    }


    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        category = coder.decodeObject(forKey: "category") as? String
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuDetailIdentifier"{
            let detailMenuTableViewController = segue.destination as? MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            detailMenuTableViewController?.menuItem = menuItems[index]
        }
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuIdentifier", for: indexPath)
        
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
           let menuString = menuItems[indexPath.row]
        cell.textLabel?.text = menuString.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuString.price)
        MenuController.shared.fetchImages(url: menuString.imageURL){ image in
            guard let image = image else {return}
            DispatchQueue.main.async {
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath{
                    return
                }
            cell.imageView?.image = image
            cell.setNeedsLayout()
            }
        }
       }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
