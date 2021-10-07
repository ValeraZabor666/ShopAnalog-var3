//
//  TargetPresenter.swift
//  MobileUp
//
//  Created by Captain Kidd on 27.07.2021.
//

import Foundation

protocol TargetPresenterProtocol {
    var router: TargetRouterProtocol? { get set }
    var interactor: TargetInteractorProtocol? { get set }
    var view: TargetViewControllerProtocol? { get set }
}

class TargetPresenter: TargetPresenterProtocol {
    
    var router: TargetRouterProtocol?
    var interactor: TargetInteractorProtocol?
    var view: TargetViewControllerProtocol?
    
}

