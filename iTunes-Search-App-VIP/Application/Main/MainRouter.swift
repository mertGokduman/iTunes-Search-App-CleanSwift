//
//  MainRouter.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

@objc protocol MainRoutingLogic {
    func routeToDetail(destination: DetailViewController, indexPath: IndexPath)
}

protocol MainDataPassing {
  var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {

  weak var viewController: MainViewController?
  var dataStore: MainDataStore?
  
  // MARK: Routing
    func routeToDetail(destination: DetailViewController,
                       indexPath: IndexPath) {
        let destinationVC = destination
        var destinationDS = destinationVC.router!.dataStore!
        navigateToDetail(source: viewController!,
                         destination: destination)
        passImageToDetail(source: self.dataStore!,
                          destination: &destinationDS,
                          indexPath: indexPath)
    }

  // MARK: Navigation
    func navigateToDetail(source: MainViewController,
                          destination: DetailViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }

  // MARK: Passing data
    func passImageToDetail(source: MainDataStore,
                           destination: inout DetailDataStore,
                           indexPath: IndexPath) {
        destination.image = source.images.first(where: { $0.row == indexPath.row && $0.section == indexPath.section })?.image
    }
}
