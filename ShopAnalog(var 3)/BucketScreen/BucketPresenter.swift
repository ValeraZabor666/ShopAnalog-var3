//
//  BucketPresenter.swift
//  endlessBucket
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol BucketPresenterProtocol {
    var router: BucketRouterProtocol? { get set }
    var interactor: BucketInteractorProtocol? { get set }
    var view: BucketViewControllerProtocol? { get set }
    
    func openBucket()
    func sortByPrice(data: [GoodBucket])
    func sortByWeight(data: [GoodBucket])
    func getGoods()
    func updateGoods(data: [GoodBucket])
    func openTarget()
}

class BucketPresenter: BucketPresenterProtocol {

    var router: BucketRouterProtocol?
    var interactor: BucketInteractorProtocol?
    var view: BucketViewControllerProtocol?
    
    func getGoods() {
        interactor?.loadData()
    }
    
    func updateGoods(data: [GoodBucket]) {
        view?.setBucket(data: data)
    }
    
    func openBucket() {
        router?.openBucket()
    }
    
    func sortByWeight(data: [GoodBucket]) {
        view?.setBucket(data: (interactor?.sortByWeight(data: data))!)
    }
    
    func sortByPrice(data: [GoodBucket]) {
        view?.setBucket(data: (interactor?.sortByPrice(data: data))!)
    }
    
    func openTarget() {
        router?.openTarget()
    }
}
