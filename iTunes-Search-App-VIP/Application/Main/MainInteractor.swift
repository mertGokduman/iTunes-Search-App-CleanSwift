//
//  MainInteractor.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

protocol MainBusinessLogic {
    func fetchResults(request: Main.Something.Request)
    func rearrangeScreenShots()
    func downloadImages()
}

protocol MainDataStore {

}

class MainInteractor: MainBusinessLogic, MainDataStore {
    
    var presenter: MainPresentationLogic?
    var worker: MainWorker?

    var searchResults: [String]?
    var images: [SearchModel] = []

    let dispatchGroup = DispatchGroup()


   // MARK: - Fetch Search Results
    func fetchResults(request: Main.Something.Request) {
        worker = MainWorker()
        worker?.fetchSearchResults(request: request.model,
                                   completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let response = Main.Something.Response(model: response)
                self.searchResults = response.model.results?.compactMap { $0.screenshotUrls }.flatMap { $0 }
                self.rearrangeScreenShots()
                self.presenter?.presentSearchResults(response: response)
            case .failure(let error):
                print(error.rawValue)
            }
        })
    }

    // MARK: - Rearrange Screenshots
    func rearrangeScreenShots() {
        worker = MainWorker()
        self.searchResults?.forEach {
            dispatchGroup.enter()
            worker?.getImageDownloadSize(url: URL(string: $0)!,
                                         completion: { [weak self] url ,size, error in
                guard let self = self else { return }
                if error != nil {
                } else {
                    switch size {
                    case 0...100000:
                        let model = SearchModel(url: url,
                                                type: .under100)
                        self.images.append(model)
                    case 101000...250000:
                        let model = SearchModel(url: url,
                                                type: .between100250)
                        self.images.append(model)
                    case 251000...500000:
                        let model = SearchModel(url: url,
                                                type: .between250500)
                        self.images.append(model)
                    case 501000...Int64.max:
                        let model = SearchModel(url: url,
                                                type: .over500)
                        self.images.append(model)
                    default:
                        break
                    }
                    self.dispatchGroup.leave()
                }
            })
        }
        let mainQueue = DispatchQueue.main
        dispatchGroup.notify(queue: mainQueue) {
            self.downloadImages()
        }
    }

    func downloadImages() {
        worker = MainWorker()
        worker?.getImage(urls: self.images,
                         completion: { [weak self] type, data, response, error in
            guard let self = self else { return }
            if let data = data {
                let image = UIImage(data: data)
            }
        })
    }
}
