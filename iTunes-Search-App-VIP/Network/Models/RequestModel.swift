//
//  RequestModel.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.
//

import Foundation

enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

class RequestModel: NSObject {

    // MARK: - Properties
    var path: String {
        return ""
    }
    var parameters: [String: Any?] = [:]

    var headers: [String: String] = [:]

    var method: RequestHTTPMethod {
        return body.isEmpty ? RequestHTTPMethod.get : RequestHTTPMethod.post
    }
    var body: [String: Any?] = [:]

  // (request, response)
    var isLoggingEnabled: (Bool, Bool) {
        return (true, true)
    }

    func addBody(_ key: String, value: Any) {
        body[key] = value
    }
}

extension RequestModel {

    func urlRequest(header: [String: String]? = nil,
                    httpMethod: RequestHTTPMethod? = nil) -> URLRequest {
        var endpoint: String = NetworkManager.shared.baseUrl.appending(path)
        print(endpoint)

        for parameter in parameters {
            if let value = parameter.value as? String {
                endpoint.append("?\(parameter.key)=\(value)")
            }
        }

        var request: URLRequest = URLRequest(url: URL(string: endpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)

        if let httpMethod = httpMethod {
            request.httpMethod = httpMethod.rawValue
            print("httpMethod: \(String(describing: request.httpMethod))")
        } else {
            request.httpMethod = method.rawValue
        }

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        if let header = header {
            for item in header {
                request.addValue(item.value, forHTTPHeaderField: item.key)
                print("\(item.key) - \(item.value)")
            }
        }

        if method == RequestHTTPMethod.post || method == RequestHTTPMethod.put || method == RequestHTTPMethod.patch {
            do {
                if !body.isEmpty {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body,
                                                                  options: JSONSerialization.WritingOptions.prettyPrinted)
                }
            } catch let error {
                print("Request body parse error: \(error.localizedDescription)")
            }
        }

        return request
    }
}
