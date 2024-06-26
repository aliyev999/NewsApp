//
//  User.swift
//  NewsApp
//
//  Created by AS on 25.06.2024.
//

import Foundation

struct User: Codable {
    let id: String?
    let name: String?
    let surname: String?
    let email: String?
    var password: String?
}
