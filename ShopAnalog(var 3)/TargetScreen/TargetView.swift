//
//  TargetView.swift
//  MobileUp
//
//  Created by Captain Kidd on 27.07.2021.
//

import Foundation
import UIKit

protocol TargetViewControllerProtocol {
    var presenter: TargetPresenterProtocol? { get set }
}

class TargetViewController: UIViewController, TargetViewControllerProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var presenter: TargetPresenterProtocol?
    private var collectionView: UICollectionView?
    private var image = UIImageView()
    
    var goods: [Good] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goods = AllGoods.sharedData.goods
        view.backgroundColor = .white
        setCollectionView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reload),
                                               name: Notification.Name("reload"),
                                               object: nil)
    }
    
    @objc func reload() {
        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }
    
    //infinite scroll not working
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let indexPath = IndexPath(row: 10000, section: 0)
//        collectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
//    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: view.frame.width,
                                 height: view.frame.height)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        guard let collectionView = collectionView else {
            return
        }
        collectionView.register(TargetCollectionViewCell.self,
                            forCellWithReuseIdentifier: TargetCollectionViewCell.id)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
//        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemToShow = goods[(indexPath.row + OneGood.sharedData.count) % goods.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TargetCollectionViewCell.id,
                                                      for: indexPath) as! TargetCollectionViewCell
        let queue = DispatchQueue.global(qos: .background)
        queue.async() {
//            cell.set(info: self.goods[indexPath.row])
            cell.set(info: itemToShow)
        }
        return cell
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 40
//    }

}
