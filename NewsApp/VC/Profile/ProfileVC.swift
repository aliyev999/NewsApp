//
//  ProfileVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

enum ProfileModel: String {
    case logout = "Logout"
    case about = "About"
}

class ProfileVC: UIViewController {
    
    @IBOutlet private weak var profileTable: UITableView!
    private let loggedProfileMenu = [["Change password", "password"], ["Logout", "logout"], ["About", "about"]]
    private let unloggedProfileMenu = [["Login", "login"], ["About", "about"]]
    private var profileMenu: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkUserLoggedIn()
    }
    
    private func configureUI() {
        title = "Hi, User"
        
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menuLabel.text = profileMenu[indexPath.row][0]
        cell.menuImage.image = UIImage(named: profileMenu[indexPath.row][1])
        cell.menuLabel.textColor = changeColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if profileMenu[indexPath.row][0] == "Login" {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                navigationController?.show(controller, sender: nil)
            }
        }
        if profileMenu[indexPath.row][0] == "About" {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "AboutVC") as? AboutVC {
                navigationController?.show(controller, sender: nil)
            }
        }
    }
}

extension ProfileVC {
    
    private func changeColor() -> UIColor {
        return UIColor(named: "firstColor") ?? UIColor.black
    }
    
    private func checkUserLoggedIn() {
        if UserDefaults.standard.bool(forKey: "loggedIn") {
            profileMenu = loggedProfileMenu
            
        } else {
            profileMenu = unloggedProfileMenu
        }
    }
}
