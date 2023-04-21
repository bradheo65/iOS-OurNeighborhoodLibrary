//
//  URLSessionManager.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import Foundation

final class URLSessionManager {
    
    static let shared = URLSessionManager()
    
    private let session = URLSession(configuration: .default)
    private let api = NetworkAPI()
    
    private init() { }
    
    func getImage(urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    func getDocsInfo(to data: GetDocsAPI, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = api.getDocsAPI(to: data).url else {
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
}
