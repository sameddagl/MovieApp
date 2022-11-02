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
    let apiKey = "api_key=3628cca7b1f145241f88009eac10fc7c"
    let imagePath = "https://image.tmdb.org/t/p/w500/"

}
