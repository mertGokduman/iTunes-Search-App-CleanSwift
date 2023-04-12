//
//  DetailRouter.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.

import UIKit

@objc protocol DetailRoutingLogic {

}

protocol DetailDataPassing {
  var dataStore: DetailDataStore? { get }
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing {
    
  weak var viewController: DetailViewController?
  var dataStore: DetailDataStore?
  
  // MARK: Routing

}
