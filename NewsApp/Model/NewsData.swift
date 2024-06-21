//
//  GetNewsData.swift
//  NewsApp
//
//  Created by AS on 19.06.24.
//

import Foundation

class NewsData {
    private let fileName = "news"
    
    func getNews(news: inout [News]) {
        if let file = Bundle.main.url(forResource: self.fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                news = try JSONDecoder().decode([News].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func falseAllFavorites() {
        // Получаем URL для директории Documents
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Создаем URL для файла news.json в директории Documents
            let fileURL = documentsDirectory.appendingPathComponent("\(fileName).json")
            
            do {
                // Загружаем данные из файла
                let data = try Data(contentsOf: fileURL)
                var news = try JSONDecoder().decode([News].self, from: data)
                
                // Обновляем все новости, устанавливая isFavorite в false
                for index in news.indices {
                    news[index].isFavorite = false
                }
                
                // Кодируем обновленные данные обратно в JSON
                let updatedData = try JSONEncoder().encode(news)
                
                // Записываем обновленные данные в файл в директории Documents
                try updatedData.write(to: fileURL, options: .atomic)
                print("Файл успешно обновлен: \(fileURL)")
            } catch {
                print("Ошибка при обновлении файла: \(error.localizedDescription)")
            }
        }
    }
}
