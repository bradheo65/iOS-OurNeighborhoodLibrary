//
//  URLSessionManager.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import Foundation

enum CustomError: Error {
    case JsonDecode
}

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
    
    func fetchPopularBookList(to data: PopularBookAPIInfo, completion: @escaping ([PopularBookDocElement], Error) -> Void) {
        guard let url = api.fetchAPIList(to: data).url else {
            return
        }
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Asd")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(PopularBook.self, from: data)
                    completion(jsonData.response.docs, CustomError.JsonDecode)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func fetchHotBookList(to data: HotBookAPIInfo, completion: @escaping ([HotBookResultElement], Error) -> Void) {
        guard let url = api.fetchAPIList(to: data).url else {
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(HotBook.self, from: data)
                    completion(jsonData.response.results, CustomError.JsonDecode)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }

}
