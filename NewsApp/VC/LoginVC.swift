//
//  LoginVC.swift
//  NewsApp
//
//  Created by AS on 16.06.24.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            repeatPasswordField.isHidden = true
            actionButton.setTitle("Login", for: .normal)
        case 1:
            repeatPasswordField.isHidden = false
            actionButton.setTitle("Register", for: .normal)
        default:
            break
        }
    }
}
