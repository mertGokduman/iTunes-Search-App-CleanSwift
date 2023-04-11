//
//  MainPresenter.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

protocol MainPresentationLogic {
    func presentSearchResults(response: Main.Something.Response)
    func displayImage(indexPath: IndexPath)
}

class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    // MARK: - Present Search Results
    func presentSearchResults(response: Main.Something.Response) {

        let viewModel = SearchListViewModel(imageGroup1: response.model.under100,
                                            imageGroup2: response.model.between100250,
                                            imageGroup3: response.model.between250500,
                                            imageGroup4: response.model.over500)
        viewController?.displaySearchResults(viewModel: Main.Something.ViewModel(model: viewModel))
    }

    func displayImage(indexPath: IndexPath) {
        viewController?.displaySearchImage(indexPath: indexPath)
    }
}
