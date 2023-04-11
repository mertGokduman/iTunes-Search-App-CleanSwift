//
//  MainWorker.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

class MainWorker {

    let queue = OperationQueue()
    let session = URLSession(configuration: URLSessionConfiguration.default,
                             delegate: nil,
                             delegateQueue: nil)

    // MARK: - GET SEARCH RESULTS
    func fetchSearchResults(request: SearchRequestModel,
                            completion: @escaping(Swift.Result<SearchResponseModel, ErrorType>) -> Void) {
        NetworkManager.shared.sendRequest(request: request,
                                          type: SearchResponseModel.self,
                                          completion: completion)
    }

    // MARK: - GET IMAGE SIZES
    func getImageDownloadSize(url: URL,
                              completion: @escaping (URL, Int64, Error?) -> Void) {
        let timeoutInterval = 5.0
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: timeoutInterval)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let contentLength = response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            completion(url, contentLength, error)
        }.resume()
    }

    // MARK: - GET IMAGES USING MAX 3 THREAD
    func getImage(urls: [SearchModel],
                  completion: @escaping( ImageSize, Data?, URLResponse?, Error?) -> Void?) {
        queue.maxConcurrentOperationCount = 3

        let completionOperation = BlockOperation {
            print("Download all images")
        }
        for item in urls {
            let operation = DownloadOperation(session: session,
                                              downloadTaskURL: item.url) { [weak self] data, response, error in
                guard let _ = self else { return }
                if error == nil {
                    completion(item.type, data, response, error)
                }
            }
            completionOperation.addDependency(operation)
            queue.addOperation(operation)
        }
        queue.addOperation(completionOperation)
    }
}
