//
//  NetworkAPI.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import Foundation

protocol BookAPIable { }

struct PopularBookAPIInfo: BookAPIable {
    let startDt: String
    let endDt: String
    let fromeAge: String
    let toAge: String
    let pageSize: String
}

struct HotBookAPIInfo: BookAPIable {
    let searchDt: String
}

struct NetworkAPI {
    static let token = "12dc79fa4b3b053239ba553b22bb83b7c53b047785af7f4132a5bcaf4efb908c"
    static let format = "json"
    static let schema = "https"
    static let host = "data4library.kr"
    static let path = "/api/loanItemSrch"
    static let hotBookPath = "/api/hotTrend"

    func fetchAPIList(to data: BookAPIable) -> URLComponents {
        if let data = data as? PopularBookAPIInfo {
            var components = URLComponents()
            components.scheme = NetworkAPI.schema
            components.host = NetworkAPI.host
            components.path = NetworkAPI.path
            
            components.queryItems = [
                URLQueryItem(name: "authKey", value: NetworkAPI.token),
                URLQueryItem(name: "startDt", value: data.startDt),
                URLQueryItem(name: "endDt", value: data.endDt),
                URLQueryItem(name: "%20gender", value: "0"),
                URLQueryItem(name: "from_age", value: data.fromeAge),
                URLQueryItem(name: "to_age", value: data.toAge),
                URLQueryItem(name: "region", value: "11"),
                URLQueryItem(name: "addCode", value: "0"),
                URLQueryItem(name: "kdc", value: "8"),
                URLQueryItem(name: "pageSize", value: data.pageSize),
                URLQueryItem(name: "format", value: NetworkAPI.format)
            ]
            return components
        }
        
        if let data = data as? HotBookAPIInfo {
            var components = URLComponents()
            components.scheme = NetworkAPI.schema
            components.host = NetworkAPI.host
            components.path = NetworkAPI.hotBookPath
            
            components.queryItems = [
                URLQueryItem(name: "authKey", value: NetworkAPI.token),
                URLQueryItem(name: "searchDt", value: data.searchDt),
                URLQueryItem(name: "format", value: NetworkAPI.format)
            ]
            return components
        }
        return URLComponents()
    }
}
