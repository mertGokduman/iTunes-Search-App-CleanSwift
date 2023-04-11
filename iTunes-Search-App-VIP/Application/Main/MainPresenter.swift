//
//  MainPresenter.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

protocol MainPresentationLogic {
    func presentSearchResults(response: Main.Something.Response)
}

class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    // MARK: - Present Search Results
    func presentSearchResults(response: Main.Something.Response) {

//        guard let model = response.model.results else { return }
//        let viewModel = model.map { item -> SearchListViewModel in
//            let screenShotUrls = item.screenshotUrls
//            return SearchListViewModel(screenShotUrls: screenShotUrls ?? [])
//        }
//        viewController?.displaySearchResults(viewModel: Main.Something.ViewModel(model: viewModel))
    }
}
