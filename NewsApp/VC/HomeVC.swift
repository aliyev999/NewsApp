//
//  HomeVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewContraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func updateDateLabelVisibility() {
        let shouldHideDateLabel = collectionView.contentOffset.y > 0
        dateLabel.isHidden = shouldHideDateLabel
        
        if shouldHideDateLabel {
            collectionViewContraint.constant = 0
        } else {
            collectionViewContraint.constant = 32
        }
        
        view.layoutIfNeeded()
    }
    
    private func setupUI() {
        updateDateLabelVisibility()
        getDate()
        addSearchButton()
    }
    
    private func addSearchButton() {
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func getDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        dateLabel.text = formattedDate
    }
    
    @objc 
    private func searchButtonTapped() {
        
    }
    
    @IBAction func readMoreTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "\(NewsDetailVC.self)") as! NewsDetailVC
        navigationController?.show(controller, sender: nil)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 240)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateDateLabelVisibility()
    }
}
