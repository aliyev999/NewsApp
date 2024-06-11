//
//  ProfileVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet private weak var profileTable: UITableView!
    private let loggedProfileMenu = [["Change password", "password"], ["Logout", "logout"], ["About", "about"]]
    private let unloggedProfileMenu = [["Login", "login"], ["About", "about"]]
    private var profileMenu: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hi, User"
        checkUserLoggedIn()
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
