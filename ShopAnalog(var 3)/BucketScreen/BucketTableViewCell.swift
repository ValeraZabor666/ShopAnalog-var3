//
//  BucketTableViewCell.swift
//  endlessBucket
//
//  Created by Captain Kidd on 28.08.2021.
//

import UIKit
import SnapKit


class BucketTableViewCell: UITableViewCell {

    static let id = "BucketCell"
    
    private var element: GoodBucket?
    
    private var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 1
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.numberOfLines = 1
        label.textAlignment = .natural
        return label
    }()
    
    private var weightLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.numberOfLines = 1
        label.textAlignment = .natural
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.numberOfLines = 1
        label.textAlignment = .natural
        return label
    }()
    
    private var bucketButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.isSelected = true
        return button
    }()
    
    private var countLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("+", for: .normal)
        return button
    }()
    
    private var minusButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("-", for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photo)
        contentView.addSubview(priceLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        
        bucketButton.addTarget(self, action: #selector(addToBucket), for: .touchUpInside)
        contentView.addSubview(bucketButton)
        
        plusButton.addTarget(self, action: #selector(plus), for: .touchUpInside)
        contentView.addSubview(plusButton)
        
        minusButton.addTarget(self, action: #selector(minus), for: .touchUpInside)
        contentView.addSubview(minusButton)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addToBucket(sender: UIButton, index: Int) {
            delete(data: element!)
    }
    
    @objc func plus() {
        var i = 0
        for good in AllData.sharedData.goods {
            if element!.good.name == good.good.name {
                AllData.sharedData.goods[i].value += 1
                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                break
            }
            i += 1
        }
    }
    
    @objc func minus() {
        var i = 0
        for good in AllData.sharedData.goods {
            if element!.good.name == good.good.name {
                if AllData.sharedData.goods[i].value == 1 {
                    delete(data: element!)
                    break
                }
                AllData.sharedData.goods[i].value -= 1
                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                break
            }
            i += 1
        }
    }
    
    func delete(data: GoodBucket) {
        var i = 0
        for good in AllData.sharedData.goods {
            if data.good.name == good.good.name {
                AllData.sharedData.goods.remove(at: i)
                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                break
            }
            i += 1
        }
    }
    
    func set(info: GoodBucket) {
        DispatchQueue.main.async {
            self.nameLabel.text = info.good.name
            self.priceLabel.text = "price: \(info.good.price)"
            self.weightLabel.text = "weight: \(info.good.weight)"
            self.descriptionLabel.text = info.good.desc.htmlToString
            self.countLabel.text = "q-t: \(info.value)"
            self.element = info
        }
        
        let imageURL: URL = URL(string: info.good.image)!

        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)) {
            let img = UIImage(data: cachedResponse.data)
            DispatchQueue.main.async {
                self.photo.image = img
            }
            return
        }

            let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data,response,error in
                if let data = data {
                    DispatchQueue.main.async() {
                        self!.photo.image = UIImage(data: data)!
                    }
                }
            }
            dataTask.resume()
    }
    
    private func imageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    private func setConstraints() {
        photo.snp.makeConstraints { maker in
            maker.top.left.bottom.equalTo(contentView).inset(10)
            maker.width.equalTo(150)
        }
        
        priceLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel).inset(60)
            maker.left.equalTo(photo).inset(160)
            maker.right.equalTo(contentView).inset(-10)
            maker.height.equalTo(30)
        }
        
        weightLabel.snp.makeConstraints { maker in
            maker.top.equalTo(priceLabel).inset(30)
            maker.left.equalTo(photo).inset(160)
            maker.right.equalTo(contentView).inset(-10)
            maker.height.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(weightLabel).inset(30)
            maker.left.equalTo(photo).inset(160)
            maker.right.equalTo(contentView).inset(-10)
            maker.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(contentView).inset(10)
            maker.left.equalTo(photo).inset(160)
            maker.right.equalTo(bucketButton).inset(-10)
            maker.height.equalTo(50)
        }
        
        bucketButton.snp.makeConstraints { maker in
            maker.top.right.equalTo(contentView).inset(10)
            maker.width.height.equalTo(50)
        }
        
        countLabel.snp.makeConstraints { maker in
            maker.top.equalTo(bucketButton).inset(50)
            maker.right.equalTo(bucketButton).inset(10)
            maker.width.height.equalTo(50)
        }
        
        plusButton.snp.makeConstraints { maker in
            maker.top.equalTo(countLabel).inset(30)
            maker.right.equalTo(contentView).inset(10)
            maker.width.height.equalTo(45)
        }
        
        minusButton.snp.makeConstraints { maker in
            maker.top.equalTo(countLabel).inset(30)
            maker.right.equalTo(plusButton).inset(25)
            maker.width.height.equalTo(45)
        }
        
    }
}
