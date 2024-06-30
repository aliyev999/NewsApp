//
//  HomeVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewContraint: NSLayoutConstraint!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        collectionView.register(UINib(nibName: "\(CategoriesHeader.self)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(CategoriesHeader.self)")
        updateDateLabelVisibility()
        addSearchButton()
        getDate()
        
        viewModel.callback = {
            self.collectionView.reloadData()
        }
        
        viewModel.getData()
    }
    
    //Hides current date on scroll
    private func updateDateLabelVisibility() {
        let shouldHideDateLabel = collectionView.contentOffset.y > 0
        dateLabel.isHidden = shouldHideDateLabel
        
        if shouldHideDateLabel {
            collectionViewContraint.constant = 0
        } else {
            collectionViewContraint.constant = 14
        }
        view.layoutIfNeeded()
    }
    
    //Navbar search button
    private func addSearchButton() {
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    //GetCurrentDate
    private func getDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        dateLabel.text = formattedDate
    }
    //Search button action
    @objc
    private func searchButtonTapped() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        navigationController?.show(controller, sender: nil)
    }
}

//News list CollectionView Settings
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let newsItem = viewModel.filteredNewsList[indexPath.row]
        cell.newsHeader.text = newsItem.header
        cell.newsText.text = newsItem.text
        cell.newsImage.image = UIImage(named: newsItem.image ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller =  storyboard?.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        controller.selectedNews = viewModel.newsList[indexPath.row]
        navigationController?.show(controller, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoriesHeader", for: indexPath) as! CategoriesHeader
        header.selectedCallback = { [weak self]selectedCategory in
            if selectedCategory != nil {
                self?.viewModel.filterDataByCategory(selectedCategory)
            } else {
                self?.viewModel.resetFilter()
            }
        }
        return header
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateDateLabelVisibility()
    }
}
