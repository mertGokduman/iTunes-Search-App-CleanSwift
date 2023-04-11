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
            let model: SearchResponseModel
        }

        struct ViewModel {
            var model: [SearchListViewModel]
        }
    }
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
}

struct SearchListViewModel {
    let image: UIImage
    let type: ImageSize
}
