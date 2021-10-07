//
//  GalleryPresenter.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol GalleryPresenterProtocol {
    var router: GalleryRouterProtocol? { get set }
    var interactor: GalleryInteractorProtocol? { get set }
    var view: GalleryViewControllerProtocol? { get set }
    
    func openBucket()
    func sortByPrice(data: [Good])
    func sortByWeight(data: [Good])
    func getGoods()
    func updateGoods(data: [Good])
    func openTarget(data: [Good], index: Int)
    
}

class GalleryPresenter: GalleryPresenterProtocol {

    var router: GalleryRouterProtocol?
    var interactor: GalleryInteractorProtocol?
    var view: GalleryViewControllerProtocol?
    
    func getGoods() {
        interactor?.loadData()
    }
    
    func updateGoods(data: [Good]) {
        view?.setGallery(data: data)
    }
    
    func openBucket() {
        router?.openBucket()
    }
    
    func sortByWeight(data: [Good]) {
        view?.setGallery(data: (interactor?.sortByWeight(data: data))!)
    }
    
    func sortByPrice(data: [Good]) {
        view?.setGallery(data: (interactor?.sortByPrice(data: data))!)
    }
    
    func openTarget(data: [Good], index: Int) {
        router?.openTarget(data: data, index: index)
    }
}
