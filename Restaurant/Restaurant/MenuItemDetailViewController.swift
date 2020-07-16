//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

protocol AddToOrderDelegate{
    func added(menuItem: MenuItem)
}
class MenuItemDetailViewController: UIViewController {
    
    var menuItem: MenuItem?
    var delegate: AddToOrderDelegate?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToOrderButton.layer.cornerRadius = 5.0
        updateUI()
        setUpDelegate()
        
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
      super.decodeRestorableState(with: coder)
      
        let menuItemID = Int(coder.decodeInt32(forKey: "menuItemId"))
        menuItem = MenuController.shared.item(withId: menuItemID)!
        updateUI()
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        guard let menuItem = menuItem else {return}
        
        super.encodeRestorableState(with: coder)
        coder.encode(menuItem.id, forKey: "menuItemId")
       }
    
    
    func updateUI(){
        guard let menuItem = menuItem else {return}
        
        titleLabel.text = menuItem.name
        priceLabel.text = String(format:"$%.2f", menuItem.price)
        descriptionLabel.text = menuItem.detailText
        MenuController.shared.fetchImages(url: menuItem.imageURL){ image in
            guard let image = image else {return}
            DispatchQueue.main.async {
                self.imageView?.image = image
            }
        }
    }

    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        guard let menuItem = menuItem else {return}
        
        UIView.animate(withDuration: 0.3){
        self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        delegate?.added(menuItem: menuItem)
        
        
    }
    
    func setUpDelegate(){
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController{
            if let orderTableViewController = navController.viewControllers.first as? OrderTableViewController{
                delegate = orderTableViewController
            }
        }
    }
    
   

}
