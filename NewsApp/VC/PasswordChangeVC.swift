import UIKit

class PasswordChangeVC: UIViewController {
    
    @IBOutlet private weak var currentPassword: UITextField!
    @IBOutlet private weak var newPassword: UITextField!
    @IBOutlet private weak var repeatNewPassword: UITextField!
    
    let userData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func successAction() {
        let alert = UIAlertController(title: "", message: "Password changed successfully", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.view.tintColor = UIColor(named: "firstColor")
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        userData.loadUsers()
        
        guard let currentPassword = currentPassword.text, !currentPassword.isEmpty,
              let newPassword = newPassword.text, !newPassword.isEmpty,
              let repeatPassword = repeatNewPassword.text, !repeatPassword.isEmpty else {
            showError(message: "Please fill in all fields")
            return
        }
        
        guard let loggedInUserID = UserDefaults.standard.string(forKey: "loggedInUserID") else {
            showError(message: "User not logged in")
            return
        }
        
        guard newPassword == repeatPassword else {
            showError(message: "Passwords do not match")
            return
        }
        
        if !Regex.isPasswordValid(newPassword) {
            showError(message: "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.")
            return
        }
        
        userData.updateUser(userId: loggedInUserID, newPassword: newPassword)
        
        successAction()
        clearFields()
    }
    
    private func clearFields() {
        self.currentPassword.text = ""
        self.newPassword.text = ""
        self.repeatNewPassword.text = ""
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.view.tintColor = UIColor(named: "firstColor")
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
