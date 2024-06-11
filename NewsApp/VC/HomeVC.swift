//
//  HomeVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: "loggedIn")
    }
  
    @IBAction func buttonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(NewsDetailVC.self)") as! NewsDetailVC
        navigationController?.show(controller, sender: nil)
    }
}
