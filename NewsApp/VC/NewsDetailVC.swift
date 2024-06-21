//
//  NewsDetailVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class NewsDetailVC: UIViewController {
    
    @IBOutlet private weak var readingTimeLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var category: UILabel!
    
    var selectedNews: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        addStarButton()
        readingTimeLabel.text = "\(calculateReadingTime(for: textView.text, wordsPerMinute: 200)) min"
        currentNews()
        isFavorite()
    }
    
    //Load selected news
    private func currentNews(){
        textView.text = selectedNews?.text
        header.text = selectedNews?.header
        date.text = selectedNews?.date
        if let currentAuthor = selectedNews?.author {
            author.text = "Published by \(currentAuthor)"
        }
        image.image = UIImage(named: selectedNews?.image ?? "")
        category.text = selectedNews?.category?.rawValue
    }
    
    //Calculate read time
    private func calculateReadingTime(for text: String, wordsPerMinute: Int) -> Int {
        let words = text.split(whereSeparator: { !$0.isLetter })
        let wordCount = words.count
        let readingTime = Int(ceil(Double(wordCount) / Double(wordsPerMinute)))
        return readingTime
    }
    
    //Check favorite news
    private func isFavorite() {
        if selectedNews?.isFavorite == true {
            addStarFillButton()
        } else {
            addStarButton()
        }
    }
}

//Favorite button settings
extension NewsDetailVC {
    //Favorite button add
    private func addStarButton() {
        let starImage = UIImage(systemName: "star")
        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.rightBarButtonItem = starButton
    }
    
    //Favorite button remove
    private func addStarFillButton() {
        let starImage = UIImage(systemName: "star.fill")
        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.rightBarButtonItem = starButton
    }
    
    //Favorite button action
    @objc
    private func starButtonTapped() {
        let news = NewsData()
        if let image = navigationItem.rightBarButtonItem?.image {
            if image == UIImage(systemName: "star") {
                addStarFillButton()
            } else if image == UIImage(systemName: "star.fill") {
                addStarButton()
            }
        }
    }
}
