//
//  ProfileVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet private weak var profileTable: UITableView!
    
    let userData = UserData()
    var profileMenu: [ProfileMenuItem] = []
    var profileMenuImages: [ProfileMenuImages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension ProfileVC {
    
    private func configure() {
        checkUserLoggedIn()
    }
    
    private func changeColor() -> UIColor {
        return UIColor(named: "firstColor") ?? UIColor.black
    }
    
    private func removeData() {
        UserDefaults.standard.setValue(false, forKey: "loggedIn")
        UserDefaults.standard.removeObject(forKey: "loggedInUserID")
    }
    
    private func checkUserLoggedIn() {
        userData.loadUsers()
        let isLoggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        let loggedInUserID = UserDefaults.standard.string(forKey: "loggedInUserID")
                
        if isLoggedIn, let loggedInUserID = loggedInUserID,
           let user = userData.getAllUsers().first(where: { $0.id == loggedInUserID }) {
            if let name = user.name {
                title = "Hi, \(name)"
            }
            profileMenu = [.about, .changePassword, .logout]
            profileMenuImages = [.about, .changePassword, .logout]
        } else {
            title = "Hi"
            profileMenu = [.about, .login]
            profileMenuImages = [.about, .login]
        }
        profileTable.reloadData()
    }
    
}

//TableView Settings
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let menuItem = profileMenu[indexPath.row]
        let menuImage = profileMenuImages[indexPath.row]
        cell.menuLabel.text = menuItem.rawValue
        cell.menuImage.image = UIImage(named: menuImage.rawValue)
        cell.menuLabel.textColor = changeColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = profileMenu[indexPath.row]
        
        //ProfileMenu
        switch menuItem {
        case .about:
            if let controller = storyboard?.instantiateViewController(withIdentifier: "AboutVC") as? AboutVC {
                navigationController?.show(controller, sender: nil)
            }
        case .login:
            if let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                navigationController?.show(controller, sender: nil)
            }
            configure()
        case .logout:
            removeData()
//            let scene = UIApplication.shared.connectedScenes.first
//            if let sceneDelegate: SceneDelegate = scene?.delegate as? SceneDelegate {
//                sceneDelegate.HomeVC()
//            }
            configure()
        case .changePassword:
            if let controller = storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC {
                navigationController?.show(controller, sender: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
