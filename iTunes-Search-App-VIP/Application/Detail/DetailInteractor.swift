//
//  DetailInteractor.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.

import UIKit

protocol DetailBusinessLogic {
    func presentImage(request: Detail.Something.Request)
}

protocol DetailDataStore {
    var image: UIImage? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {

    var presenter: DetailPresentationLogic?
    var image: UIImage?

    // MARK: Do something
    func presentImage(request: Detail.Something.Request) {

        if let image = image {
            let response = Detail.Something.Response(image: image)
            presenter?.presentImage(response: response)
        }
    }
}
