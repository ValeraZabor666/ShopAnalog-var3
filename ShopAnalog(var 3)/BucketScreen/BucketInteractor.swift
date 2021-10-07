//
//  BucketInteractor.swift
//  endlessBucket
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol BucketInteractorProtocol {
    var presenter: BucketPresenterProtocol? { get set }

    func loadData()
    func sortByPrice(data: [GoodBucket]) -> [GoodBucket]
    func sortByWeight(data: [GoodBucket]) -> [GoodBucket]
}

class BucketInteractor: BucketInteractorProtocol {
    
    var presenter: BucketPresenterProtocol?
    
    func sortByWeight(data: [GoodBucket]) -> [GoodBucket] {
        var arr = data
        arr.sort { $0.good.weight < $1.good.weight }
        return arr
    }
    
    func sortByPrice(data: [GoodBucket]) -> [GoodBucket] {
        var arr = data
        arr.sort { $0.good.price < $1.good.price }
        return arr
    }
    
    func loadData() {
        let bucketArray = AllData.sharedData.goods
        self.presenter?.updateGoods(data: bucketArray)
    }
    
}
