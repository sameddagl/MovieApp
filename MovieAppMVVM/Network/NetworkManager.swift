//
//  NetworkManager.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func requestData(dataType: DataType, page: Int, completion: @escaping(Swift.Result<Movie, Error>) -> Void)
}

public enum DataType: String{
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case popular = "popular"
    case upcoming = "upcoming"
}

final class NetworkManager: NetworkManagerProtocol{
    static let shared = NetworkManager()
    
    func requestData(dataType: DataType, page: Int, completion: @escaping(Swift.Result<Movie, Error>) -> Void){
        let url = "\(NetworkHelper.shared.baseURL)\(dataType.rawValue)?\(NetworkHelper.shared.apiKey)&page=\(page)&language=en-US"
        print(url)
        let request = AF.request(url, method: .get)
        print("network manager")
        
        request.responseDecodable(of: Movie.self) { response in
            switch response.result{
            case .success(let movie):
                print("success")
                completion(.success(movie))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    func requestCast(movieID: Int, completion: @escaping(Swift.Result<Credits, Error>) -> Void){
        let url = "\(NetworkHelper.shared.baseURL)\(movieID)/credits?\(NetworkHelper.shared.apiKey)&language=en-US"
        print(url)
        let request = AF.request(url, method: .get)
        print("network manager")
        
        request.responseDecodable(of: Credits.self) { response in
            switch response.result{
            case .success(let movie):
                print("success")
                completion(.success(movie))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
