//
//  BaseScreenPresenter.swift
//  ShopAnalog(var 3)
//
//  Created by Captain Kidd on 07.10.2021.
//

import Foundation

protocol BasePresenterProtocol {
    var router: BaseRouterProtocol? { get set }
    var view: BaseViewControllerProtocol? { get set }
    
    func openGallery()
    func openBucket()
}

class BasePresenter: BasePresenterProtocol {

    var router: BaseRouterProtocol?
    var view: BaseViewControllerProtocol?
    
    func openBucket() {
        router?.openBucket()
    }
    
    func openGallery() {
        router?.openGallery()
    }
}
