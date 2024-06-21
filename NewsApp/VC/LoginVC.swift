//
//  LoginVC.swift
//  NewsApp
//
//  Created by AS on 16.06.24.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
}
    //Hides textfields in login and register
    private func isHidden(){
        repeatPasswordField.isHidden.toggle()
        nameField.isHidden.toggle()
        surnameField.isHidden.toggle()
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            isHidden()
            actionButton.setTitle("Login", for: .normal)
        case 1:
            isHidden()
            actionButton.setTitle("Register", for: .normal)
        default:
            break
        }
    }
}
