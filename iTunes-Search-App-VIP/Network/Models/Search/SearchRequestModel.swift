//
//  SearchRequestModel.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.
//

import Foundation

final class SearchRequestModel: RequestModel {

    override var path: String {
        return "term=Swift&media=software&entity=software, iPadSoftware, macSoftware&limit=10"
    }
}

