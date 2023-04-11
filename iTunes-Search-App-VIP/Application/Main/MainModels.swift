//
//  MainModels.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

enum Main {
    // MARK: Use cases

    enum Something {
        struct Request {
            let model: SearchRequestModel
        }

        struct Response {
            let model: Images
        }

        struct ViewModel {
            var model: SearchListViewModel
        }
    }
}

struct Images {
    let under100: [URL]
    let between100250: [URL]
    let between250500: [URL]
    let over500: [URL]
}

enum ImageSize {
    case under100
    case between100250
    case between250500
    case over500
}

struct SearchModel {
    let url: URL
    let type: ImageSize
    let row: Int
    let section: Int
    var image: UIImage?
}

struct SearchListViewModel {
    let imageGroup1: [URL]
    let imageGroup2: [URL]
    let imageGroup3: [URL]
    let imageGroup4: [URL]
}
