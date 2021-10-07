//
//  TargetRouter.swift
//  MobileUp
//
//  Created by Captain Kidd on 27.07.2021.
//

import Foundation
import UIKit

protocol TargetRouterProtocol {
    
    var entry: UIViewController? { get }
    static func start() -> TargetRouterProtocol
}

class TargetRouter: TargetRouterProtocol {
    
    var entry: UIViewController?
    
    static func start() -> TargetRouterProtocol {
        let router = TargetRouter()
        
        //vip
        var view: TargetViewControllerProtocol = TargetViewController()
        var presenter: TargetPresenterProtocol = TargetPresenter()
        var interactor: TargetInteractorProtocol = TargetInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? UIViewController
        
        return router
    }
    
}
