//
//  BucketRouter.swift
//  endlessBucket
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit

typealias EntryPoint2 = BucketViewControllerProtocol & UIViewController

protocol BucketRouterProtocol {
    
    var entry: EntryPoint2? { get }
    static func start() -> BucketRouterProtocol
    
    func openTarget(data: [Good], index: Int)
    func openBucket()
}

class BucketRouter: BucketRouterProtocol {
    
    var entry: EntryPoint2?
    
    static func start() -> BucketRouterProtocol {
        let router = BucketRouter()
        
        //vip
        var view: BucketViewControllerProtocol = BucketViewController()
        var presenter: BucketPresenterProtocol = BucketPresenter()
        var interactor: BucketInteractorProtocol = BucketInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? EntryPoint2
        
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
        let vc = GalleryRouter.start()
        let destVc = vc.entry
        entry?.navigationController?.pushViewController(destVc!, animated: true)
    }
}
