//
//  TargetInteractor.swift
//  MobileUp
//
//  Created by Captain Kidd on 27.07.2021.
//

import Foundation

protocol TargetInteractorProtocol {
    var presenter: TargetPresenterProtocol? { get set }

}

class TargetInteractor: TargetInteractorProtocol{
    
    
    var presenter: TargetPresenterProtocol?
    
}
