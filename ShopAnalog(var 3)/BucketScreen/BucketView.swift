//
//  BucketView.swift
//  endlessBucket
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit
import SnapKit

protocol BucketViewControllerProtocol {
    var presenter: BucketPresenterProtocol? { get set }
    
    func setBucket(data: [GoodBucket])
}

class BucketViewController: UIViewController, BucketViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: BucketPresenterProtocol?
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(BucketTableViewCell.self,
                       forCellReuseIdentifier: BucketTableViewCell.id)
        return table
    }()
    private var segmentSort = UISegmentedControl()
    
    var goods: [GoodBucket] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var sumLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.getGoods()
        
        setSegmentControl()
        setTableView()
        setNavigationButton()
        setSum()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reload),
                                               name: Notification.Name("reload"),
                                               object: nil)
    }
    
    @objc func reload() {
        goods = AllData.sharedData.goods
        sumLabel.text = "total price: \(countSum())"
    }
    
    private func setSum() {
        sumLabel.backgroundColor = .red
        sumLabel.textColor = .white
        sumLabel.textAlignment = .center
        view.addSubview(sumLabel)
        setConstraint()
        sumLabel.text = "total price: \(countSum())"
    }
    
    private func setConstraint() {
        sumLabel.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview().inset(40)
            maker.height.equalTo(60)
        }
    }
    
    private func countSum() -> Double {
        var sum = 0.0
        for good in AllData.sharedData.goods {
            sum += good.good.price * Double(good.value)
        }
        return sum
    }
    
    func setBucket(data: [GoodBucket]) {
        goods = data
    }
    
    private func setNavigationButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "book"),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: BucketTableViewCell.id,
                                                 for: indexPath) as! BucketTableViewCell
        let queue = DispatchQueue.global(qos: .background)
        queue.async() {
            cell.set(info: self.goods[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data: [Good] = []
        for good in goods {
            data.append(good.good)
        }
        
        presenter?.openTarget(data: data, index: indexPath.row)
    }
    
}
