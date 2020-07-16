//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Павел on 6/13/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    var minutes: Int!
    
   
    
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    override func viewDidLoad() {
           super.viewDidLoad()

           timeRemainingLabel.text = "Wait time - \(minutes!) minutes"
       }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
