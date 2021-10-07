//
//  BaseScreenView.swift
//  ShopAnalog(var 3)
//
//  Created by Captain Kidd on 07.10.2021.
//

import Foundation
import UIKit

protocol BaseViewControllerProtocol {
    var presenter: BasePresenterProtocol? { get set }
    
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    var presenter: BasePresenterProtocol?
    
    var galleryButton = UIButton()
    var bucketButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
        setConstraints()
        view.backgroundColor = .white
    }
    
    private func setButtons() {
        galleryButton.backgroundColor = .black
        galleryButton.layer.cornerRadius = 10
        galleryButton.clipsToBounds = true
        galleryButton.setTitle("Gallery", for: .normal)
        galleryButton.titleLabel?.textColor = .white
        galleryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        view.addSubview(galleryButton)
        
        bucketButton.backgroundColor = .black
        bucketButton.layer.cornerRadius = 10
        bucketButton.clipsToBounds = true
        bucketButton.setTitle("Bucket", for: .normal)
        bucketButton.titleLabel?.textColor = .white
        bucketButton.addTarget(self, action: #selector(openBucket), for: .touchUpInside)
        view.addSubview(bucketButton)
    }
    
    @objc func openGallery() {
        presenter?.openGallery()
    }
    
    @objc func openBucket() {
        presenter?.openBucket()
    }
    
    private func setConstraints() {
        galleryButton.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(50)
            maker.bottom.equalToSuperview().inset(50)
            maker.height.equalTo(70)
        }
        
        bucketButton.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(50)
            maker.top.equalToSuperview().inset(100)
            maker.height.equalTo(70)
        }
    }
}
