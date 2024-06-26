import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet private weak var profileTable: UITableView!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "firstColor")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
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
    
    private func confirmLogout() {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            self.startLoading() // Начать показ activityIndicator
                DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 2)
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.removeData()
                    self.configure()
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        present(alert, animated: true)
    }
    
    private func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

// TableView Settings
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileMenu.count
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
        
        // ProfileMenu
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
            confirmLogout()
        case .changePassword:
            if let controller = storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC {
                navigationController?.show(controller, sender: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
