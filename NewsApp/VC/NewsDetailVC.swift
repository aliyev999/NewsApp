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
       
        readingTimeLabel.text = "\(calculateReadingTime(for: textView.text, wordsPerMinute: 200)) min"
    }
    
    private func calculateReadingTime(for text: String, wordsPerMinute: Int) -> Int {
        let words = text.split(separator: " ").count
        let readingTimeInMinutes = words / wordsPerMinute
        return readingTimeInMinutes
    }
}
