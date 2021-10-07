//
//  GalleryTableViewCell.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import UIKit
import SnapKit


class GalleryTableViewCell: UITableViewCell {

    static let id = "GalleryCell"
    
    private var element: Good?
    
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
        button.backgroundColor = .cyan
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.isSelected = false
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photo)
        contentView.addSubview(priceLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(nameLabel)
        
        bucketButton.addTarget(self, action: #selector(addToBucket), for: .touchUpInside)
        contentView.addSubview(bucketButton)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addToBucket(sender: UIButton) {
        
        if sender.isSelected == false {
            add(data: element!)
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        } else {
            delete(data: element!)
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        }
    }
    
    func add(data: Good) {
        let new = GoodBucket(good: data, value: 1)
        AllData.sharedData.goods.append(new)
    }
    
    func delete(data: Good) {
        var i = 0
        for good in AllData.sharedData.goods {
            if data.name == good.good.name {
                AllData.sharedData.goods.remove(at: i)
                break
            }
            i += 1
        }
    }
    
    func set(info: Good) {
        DispatchQueue.main.async {
            self.nameLabel.text = info.name
            self.priceLabel.text = "price: \(info.price)"
            self.weightLabel.text = "weight: \(info.weight)"
            self.descriptionLabel.text = info.desc.htmlToString
            self.element = info
            self.bucketButton.backgroundColor = .cyan
            self.bucketButton.isSelected = false
            for good in AllData.sharedData.goods {
                if info.name == good.good.name {
                    self.bucketButton.backgroundColor = .yellow
                    self.bucketButton.isSelected = true
                    break
                }
            }
        }
        
        let imageURL: URL = URL(string: info.image)!

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
                        self?.imageToCache(data: data, response: response!)
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
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
