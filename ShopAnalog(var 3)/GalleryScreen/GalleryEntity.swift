//
//  GalleryEntity.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit
import RealmSwift

struct Good: Codable {
    var image: String
    var price: Double
    var name: String
    var weight: Double
    var id: String
    var desc: String
}

struct GoodBucket {
    var good: Good
    var value: Int
}

class AllData {
    static let sharedData = AllData()
    
    var goods: [GoodBucket] = []
}
