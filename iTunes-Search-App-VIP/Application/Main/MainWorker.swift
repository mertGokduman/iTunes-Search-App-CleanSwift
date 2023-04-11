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
                  completion: @escaping( SearchModel, URLResponse?, Error?) -> Void?) {
        guard !urls.isEmpty else { return }
        queue.maxConcurrentOperationCount = 3

        let completionOperation = BlockOperation {
            print("Download all images")
        }
        for index in 0...(urls.count - 1) {
            let operation = DownloadOperation(session: session,
                                              downloadTaskURL: urls[index].url) { [weak self] data, response, error in
                guard let _ = self else { return }
                if error == nil,
                   data != nil {
                    completion(SearchModel(url: urls[index].url,
                                           type: urls[index].type,
                                           row: urls[index].row,
                                           section: urls[index].section,
                                           image: UIImage(data: data!)), response, error)
                }
            }
            completionOperation.addDependency(operation)
            queue.addOperation(operation)
        }
        queue.addOperation(completionOperation)
    }
}
