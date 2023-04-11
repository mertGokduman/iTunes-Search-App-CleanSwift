//
//  SearchRequestModel.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.
//

import Foundation

final class SearchRequestModel: RequestModel {

    var searchTerm: String?

    override var path: String {
        if let searchTerm = searchTerm {
            return "term=\(searchTerm)&media=software&entity=software, iPadSoftware, macSoftware&limit=20"
        } else {
            return "term=&media=software&entity=software, iPadSoftware, macSoftware&limit=20"
        }
    }

    init(searchTerm: String) {
        if searchTerm.contains(" ") {
            let searchString = searchTerm.replacingOccurrences(of: " ",
                                                               with: "+")
            self.searchTerm = searchString
        } else {
            self.searchTerm = searchTerm
        }

    }
}

