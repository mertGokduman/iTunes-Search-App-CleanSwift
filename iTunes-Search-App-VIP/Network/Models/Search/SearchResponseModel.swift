//
//  SearchResponseModel.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.
//

import Foundation

struct SearchResponseModel: Codable {

    var resultCount: Int?
    var results: [SoftwareModel]?

    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try? values.decode(Int.self, forKey: .resultCount)
        results = try? values.decode([SoftwareModel].self, forKey: .results)
    }
}

struct SoftwareModel: Codable {

    var screenshotUrls: [String]?

    enum CodingKeys: String, CodingKey {
        case screenshotUrls
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        screenshotUrls = try? values.decode([String].self, forKey: .screenshotUrls)
    }
}
