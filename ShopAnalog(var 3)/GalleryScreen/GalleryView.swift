//
//  GalleryView.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit
import RealmSwift

protocol GalleryViewControllerProtocol {
    var presenter: GalleryPresenterProtocol? { get set }
    
    func setGallery(data: [Good])
}

class GalleryViewController: UIViewController, GalleryViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: GalleryPresenterProtocol?
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(GalleryTableViewCell.self,
                       forCellReuseIdentifier: GalleryTableViewCell.id)
        return table
    }()
    private var segmentSort = UISegmentedControl()
    
    var goods: [Good] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.getGoods()
        
        setSegmentControl()
        setTableView()
        setNavigationButton()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reload),
                                               name: Notification.Name("reload"),
                                               object: nil)
    }
    
    @objc func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setGallery(data: [Good]) {
        goods = data
    }
    
    private func setNavigationButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(openBucket))
    }
    
    @objc func openBucket() {
        presenter?.openBucket()
    }
    
    private func setTableView() {
        tableView.frame  = view.bounds
        tableView.backgroundColor = UIColor(red: 0.9,
                                            green: 0.9,
                                            blue: 0.9,
                                            alpha: 1.0)
        self.tableView.rowHeight = 200
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setSegmentControl() {
        let segArr = ["price", "weight"]
        segmentSort = UISegmentedControl(items: segArr)
        segmentSort.sizeToFit()
        view.addSubview(segmentSort)
        navigationItem.titleView = segmentSort
        
        segmentSort.addTarget(self, action: #selector(sort), for: .valueChanged)
    }
    
    @objc func sort(target: UISegmentedControl) {
        let segmentIndex = target.selectedSegmentIndex
        switch segmentIndex {
        case 0: presenter?.sortByPrice(data: goods)
        case 1: presenter?.sortByWeight(data: goods)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.id,
                                                 for: indexPath) as! GalleryTableViewCell
        let queue = DispatchQueue.global(qos: .background)
        queue.async() {
            cell.set(info: self.goods[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.openTarget()
    }
}
