//
//  GetNewsData.swift
//  NewsApp
//
//  Created by AS on 19.06.24.
//

import Foundation

class GetNewsData {
    private let fileName = "news"
    
    func parseNewsFile(news: inout [News]) {
        if let file = Bundle.main.url(forResource: self.fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                news = try JSONDecoder().decode([News].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


