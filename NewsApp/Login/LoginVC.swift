import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var surnameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var actionButton: UIButton!
    private let userData = UserData()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "firstColor")
        indicator.backgroundColor =  UIColor(white: 2, alpha: 0.7)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
    }
    
    // Hides textfields in login and register
    private func isHidden() {
        repeatPasswordField.isHidden.toggle()
        nameField.isHidden.toggle()
        surnameField.isHidden.toggle()
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.view.tintColor = UIColor(named: "firstColor")
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func isEmailUnique(email: String) -> Bool {
        return !userData.getAllUsers().contains(where: { $0.email == email })
    }
    
    private func setData(id: String) {
        UserDefaults.standard.setValue(true, forKey: "loggedIn")
        UserDefaults.standard.setValue(id, forKey: "loggedInUserID")
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
}

// ActionButton & SegmentControl
extension LoginVC {
    @IBAction func actionButtonTapped(_ sender: Any) {
        userData.loadUsers()
        
        if segmentControl.selectedSegmentIndex == 0 {
            guard let email = emailField.text, !email.isEmpty,
                  let password = passwordField.text, !password.isEmpty else {
                showError(message: "Please enter email and password")
                return
            }
            
            guard Regex.isEmailValid(email) else {
                showError(message: "Please enter a valid email address")
                return
            }
            
            startLoading()
            DispatchQueue.global().async {
                if let user = self.userData.getAllUsers().first(where: { $0.email == email && $0.password == password }) {
                    self.setData(id: user.id ?? "")
                    DispatchQueue.main.async {
                        self.stopLoading()
                        let scene = UIApplication.shared.connectedScenes.first
                        if let sceneDelegate: SceneDelegate = scene?.delegate as? SceneDelegate {
                            sceneDelegate.HomeVC()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.showError(message: "Login failed. Invalid credentials.")
                    }
                }
            }
        } else if segmentControl.selectedSegmentIndex == 1 {
            guard let name = nameField.text, !name.isEmpty,
                  let surname = surnameField.text, !surname.isEmpty,
                  let email = emailField.text, !email.isEmpty,
                  let password = passwordField.text, !password.isEmpty,
                  let repeatPassword = repeatPasswordField.text, !repeatPassword.isEmpty else {
                showError(message: "Please fill in all fields")
                return
            }
            
            guard Regex.isEmailValid(email) else {
                showError(message: "Please enter a valid email address")
                return
            }
            
            guard password == repeatPassword else {
                showError(message: "Passwords do not match")
                return
            }
            
            guard isEmailUnique(email: email) else {
                showError(message: "Email is already taken")
                return
            }
            
            startLoading()
            DispatchQueue.global().async {
                // Simulate registration process
                let newUser = User(id: UUID().uuidString, name: name, surname: surname, email: email, password: password)
                self.userData.addUser(user: newUser)
                self.setData(id: newUser.id ?? "")
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.clearFields()
                }
            }
        }
    }

    
    private func clearFields() {
        nameField.text = ""
        surnameField.text = ""
        emailField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            isHidden()
            clearFields()
            emailField.becomeFirstResponder()
            actionButton.setTitle("Login", for: .normal)
        case 1:
            isHidden()
            clearFields()
            nameField.becomeFirstResponder()
            actionButton.setTitle("Register", for: .normal)
        default:
            break
        }
    }
}
