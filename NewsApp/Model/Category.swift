//
//  Category.swift
//  NewsApp
//
//  Created by AS on 19.06.24.
//

import Foundation

enum Category: String, Codable, CaseIterable {
    case world = "World"
    case business = "Business"
    case politics = "Politics"
    case tech = "Technology"
    case health = "Health"
    case arts = "Arts"
}
