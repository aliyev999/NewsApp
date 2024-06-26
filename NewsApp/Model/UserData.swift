//
//  UserData.swift
//  NewsApp
//
//  Created by AS on 25.06.2024.
//

import Foundation

class UserData {
    private let fileName = "users.json"
    private var users: [User] = []
    
    private func getUsersFileURL() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to access document directory.")
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
}
