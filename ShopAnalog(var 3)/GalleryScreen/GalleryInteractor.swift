//
//  GalleryInteractor.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol GalleryInteractorProtocol {
    var presenter: GalleryPresenterProtocol? { get set }

    func loadData()
    func sortByPrice(data: [Good]) -> [Good]
    func sortByWeight(data: [Good]) -> [Good]
}

class GalleryInteractor: GalleryInteractorProtocol {
    
    var presenter: GalleryPresenterProtocol?
    
    func sortByWeight(data: [Good]) -> [Good] {
        var arr = data
        arr.sort { $0.weight < $1.weight }
        return arr
    }
    
    func sortByPrice(data: [Good]) -> [Good] {
        var arr = data
        arr.sort { $0.price < $1.price }
        return arr
    }
    
    func loadData() {
        let urlString = "http://94.127.67.113:8099/getGoods"
        let url = URL(string: urlString)
        let decoder = JSONDecoder()
        
        getJSON(url: url!) { data, error in
            let response = try? decoder.decode([Good].self, from: data!)
            
            if response == nil {
                print("response nil")
            } else {
                self.presenter?.updateGoods(data: response!)
            }
        }
    }

    private func getJSON(url: URL, completion: @escaping (Data?, Error?) -> Void) {

        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {

        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
}
