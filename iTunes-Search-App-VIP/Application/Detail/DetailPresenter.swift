//
//  DetailPresenter.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.

import UIKit

protocol DetailPresentationLogic {
    func presentImage(response: Detail.Something.Response)
}

class DetailPresenter: DetailPresentationLogic {

    weak var viewController: DetailDisplayLogic?

    // MARK: Do something
    func presentImage(response: Detail.Something.Response) {
        let viewModel = Detail.Something.ViewModel(image: response.image)
        viewController?.displayImage(viewModel: viewModel)
    }
}
