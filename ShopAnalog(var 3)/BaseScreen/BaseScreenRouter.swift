//
//  BaseScreenRouter.swift
//  ShopAnalog(var 3)
//
//  Created by Captain Kidd on 07.10.2021.
//

import Foundation
import UIKit

typealias EntryPointBase = BaseViewControllerProtocol & UIViewController

protocol BaseRouterProtocol {
    
    var entry: EntryPointBase? { get }
    static func start() -> BaseRouterProtocol
    
    func openGallery()
    func openBucket()
}

class BaseRouter: BaseRouterProtocol {
    
    var entry: EntryPointBase?
    
    static func start() -> BaseRouterProtocol {
        let router = BaseRouter()
        
        //vip
        var view: BaseViewControllerProtocol = BaseViewController()
        var presenter: BasePresenterProtocol = BasePresenter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        router.entry = view as? EntryPointBase
        
        return router
    }
    
    func openBucket() {
        let vc = BucketRouter.start()
        let destVc = vc.entry
        entry?.navigationController?.pushViewController(destVc!, animated: true)
    }
    
    func openGallery() {
        let vc = GalleryRouter.start()
        let destVc = vc.entry
        entry?.navigationController?.pushViewController(destVc!, animated: true)
    }
    
}
