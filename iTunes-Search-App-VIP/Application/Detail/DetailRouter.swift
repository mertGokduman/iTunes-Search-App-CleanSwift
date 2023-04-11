//
//  DetailRouter.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.

import UIKit

@objc protocol DetailRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol DetailDataPassing
{
  var dataStore: DetailDataStore? { get }
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing
{
  weak var viewController: DetailViewController?
  var dataStore: DetailDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: DetailViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: DetailDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
