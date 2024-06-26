//
//  News.swift
//  NewsApp
//
//  Created by AS on 09.06.24.
//

import Foundation

struct News: Codable {
    let header: String?
    let text: String?
    let image: String?
    let date: String?
    let author: String?
    let category: Category?
}
