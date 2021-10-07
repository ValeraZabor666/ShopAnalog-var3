//
//  TargetView.swift
//  MobileUp
//
//  Created by Captain Kidd on 27.07.2021.
//

import Foundation
import UIKit

protocol TargetViewControllerProtocol {
    var presenter: TargetPresenterProtocol? { get set }
}

class TargetViewController: UIViewController, TargetViewControllerProtocol {
    
    var presenter: TargetPresenterProtocol?
    private var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
