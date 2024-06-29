import Foundation

class UserData {
    private let fileName = "users.json"
    private var users: [User] = []
    
    private func getUsersFileURL() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    // Function to load users from a local JSON file
    func loadUsers() {
        let fileURL = getUsersFileURL()
        guard let url = fileURL else { return }
        
        do {
            let data = try Data(contentsOf: url)
            users = try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Error loading users: \(error)")
        }
    }
    
    // Function to add a new user
    func addUser(user: User) {
        users.append(user)
        saveUsers()
    }
    
    // Function to save users to a local JSON file
    private func saveUsers() {
        let fileURL = getUsersFileURL()
        guard let url = fileURL else { return }
        
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Error saving users: \(error)")
        }
    }
    
    // Function to get all users
    func getAllUsers() -> [User] {
        return users
    }
    
    func updateUser(userId: String, newPassword: String) {
            if let index = users.firstIndex(where: { $0.id == userId }) {
                users[index].password = newPassword
                saveUsers()
            }
        }
}
