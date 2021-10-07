//
//  GalleryRouter.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit

typealias EntryPoint = GalleryViewControllerProtocol & UIViewController

protocol GalleryRouterProtocol {
    
    var entry: EntryPoint? { get }
    static func start() -> GalleryRouterProtocol
    
    func openTarget(data: [Good], index: Int)
    func openBucket()
}

class GalleryRouter: GalleryRouterProtocol {
    
    var entry: EntryPoint?
    
    static func start() -> GalleryRouterProtocol {
        let router = GalleryRouter()
        
        //vip
        var view: GalleryViewControllerProtocol = GalleryViewController()
        var presenter: GalleryPresenterProtocol = GalleryPresenter()
        var interactor: GalleryInteractorProtocol = GalleryInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    func openTarget(data: [Good], index: Int) {
        let vc = TargetRouter.start()
        let destVc = vc.entry
        AllGoods.sharedData.goods = data
        OneGood.sharedData.count = index
        entry?.navigationController?.pushViewController(destVc!, animated: true)
    }
    
    func openBucket() {
        let vc = BucketRouter.start()
        let destVc = vc.entry
        entry?.navigationController?.pushViewController(destVc!, animated: true)
    }
}
