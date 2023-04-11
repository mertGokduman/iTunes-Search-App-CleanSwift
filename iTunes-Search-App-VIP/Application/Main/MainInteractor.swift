//
//  MainInteractor.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

struct ImageStr: Identifiable {
    var imageUrl: URL?
    var image: UIImage?
    var id: Int
}

protocol MainBusinessLogic: MainDataStore {
    func fetchResults(request: Main.Something.Request)
    func rearrangeScreenShots()
    func downloadImages()

}

protocol MainDataStore {
    var images: [SearchModel] { get set }
}

class MainInteractor: MainBusinessLogic {
    
    var presenter: MainPresentationLogic?
    var worker: MainWorker?

    var searchResults: [String]?

    var imageGroup1: [URL] = []
    var imageGroup2: [URL] = []
    var imageGroup3: [URL] = []
    var imageGroup4: [URL] = []
    var group1Row: Int = 0
    var group2Row: Int = 0
    var group3Row: Int = 0
    var group4Row: Int = 0

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
                guard let results = response.results else { return }
                if results.isEmpty {
                    
                } else {
                    self.searchResults = results.compactMap { $0.screenshotUrls }.flatMap { $0 }
                    self.rearrangeScreenShots()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        })
    }

    // MARK: - Rearrange Screenshots
    func rearrangeScreenShots() {
        worker = MainWorker()
        images = []
        imageGroup1 = []
        imageGroup2 = []
        imageGroup3 = []
        imageGroup4 = []
        group1Row = 0
        group2Row = 0
        group3Row = 0
        group4Row = 0
        self.searchResults?.forEach {
            dispatchGroup.enter()
            worker?.getImageDownloadSize(url: URL(string: $0)!,
                                         completion: { [weak self] url ,size, error in
                guard let self = self else { return }

                if error == nil {
                    switch size {
                    case 0...100000:
                        let model = SearchModel(url: url,
                                                type: .under100,
                                                row: self.group1Row,
                                                section: 0)
                        self.group1Row += 1
                        self.images.append(model)
                        self.imageGroup1.append(url)
                    case 101000...250000:
                        let model = SearchModel(url: url,
                                                type: .between100250,
                                                row: self.group2Row,
                                                section: 1)
                        self.group2Row += 1
                        self.images.append(model)
                        self.imageGroup2.append(url)
                    case 251000...500000:
                        let model = SearchModel(url: url,
                                                type: .between250500,
                                                row: self.group3Row,
                                                section: 2)
                        self.group3Row += 1
                        self.images.append(model)
                        self.imageGroup3.append(url)
                    case 501000...Int64.max:
                        let model = SearchModel(url: url,
                                                type: .over500,
                                                row: self.group4Row,
                                                section: 3)
                        self.group4Row += 1
                        self.images.append(model)
                        self.imageGroup4.append(url)
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
            let response = Images(under100: self.imageGroup1,
                                  between100250: self.imageGroup2,
                                  between250500: self.imageGroup3,
                                  over500: self.imageGroup4)
            self.presenter?.presentSearchResults(response: Main.Something.Response(model: response))
        }
    }

    func downloadImages() {
        worker = MainWorker()

        worker?.getImage(urls: self.images,
                         completion: { [weak self] model, response, error in
            guard let self = self else { return }
            if let selectedIndex = self.images.firstIndex(where: { $0.section == model.section && $0.row == model.row }) {
                self.images[selectedIndex] = model
            }

            self.presenter?.displayImage(indexPath: IndexPath(row: model.row,
                                                              section: model.section))
        })
    }
}
