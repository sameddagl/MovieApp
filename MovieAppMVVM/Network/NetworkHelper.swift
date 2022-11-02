//
//  NetworkHelper.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import Foundation

struct NetworkHelper {
    static let shared = NetworkHelper()
    let baseURL = "https://api.themoviedb.org/3/movie/"
    let apiKey = ""
    let imagePath = "https://image.tmdb.org/t/p/w500/"

}
