//
//  NewsDetailVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class NewsDetailVC: UIViewController {
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var readingTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        addStarButton()
        readingTimeLabel.text = "\(calculateReadingTime(for: textView.text, wordsPerMinute: 200)) min"
    }
    
    private func calculateReadingTime(for text: String, wordsPerMinute: Int) -> Int {
        let words = text.split(separator: " ").count
        let readingTimeInMinutes = words / wordsPerMinute
        return readingTimeInMinutes
    }
    
    private func addStarButton() {
        let starImage = UIImage(systemName: "star")
        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.rightBarButtonItem = starButton
    }
    
    private func addStarFillButton() {
        let starImage = UIImage(systemName: "star.fill")
        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.rightBarButtonItem = starButton
    }
    
    @objc 
    private func starButtonTapped() {
        if let image = navigationItem.rightBarButtonItem?.image {
            if image == UIImage(systemName: "star") {
                addStarFillButton()
            } else if image == UIImage(systemName: "star.fill") {
                addStarButton()
            }
        }
    }
}
