//
//  HomeVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class HomeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: "loggedIn")
    }
    
    @IBAction func readMoreTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "\(NewsDetailVC.self)") as! NewsDetailVC
        navigationController?.show(controller, sender: nil)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
}


