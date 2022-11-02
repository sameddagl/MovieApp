//
//  MainModel.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import Foundation

struct Movie: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable, MovieCellProtocol {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    var posterImage: String {
        "\(NetworkHelper.shared.imagePath)/\(posterPath)"
    }
    var titleText: String {
        title
    }
    var star: String {
        String(self.voteAverage)
    }
    var genres: [String]{
        var genreString = [String]()
        for i in genreIDS{
            switch i{
            case 28:
                genreString.append("Action")
            case 12:
                genreString.append("Adventure")
            case 16:
                genreString.append("Animation")
            case 35:
                genreString.append("Comedy")
            case 80:
                genreString.append("Crime")
            case 99:
                genreString.append("Documentary")
            case 18:
                genreString.append("Drama")
            case 10751:
                genreString.append("Family")
            case 14:
                genreString.append("Fantasy")
            case 36:
                genreString.append("History")
            case 27:
                genreString.append("Horror")
            case 10402:
                genreString.append("Music")
            case 9648:
                genreString.append("Mystery")
            case 10749:
                genreString.append("Romance")
            case 878:
                genreString.append("Science Fiction")
            case 10770:
                genreString.append("TV Movie")
            case 53:
                genreString.append("Thriller")
            case 10752:
                genreString.append("War")
            case 37:
                genreString.append("Western")
            default:
                genreString.append("")
            }
        }
        return genreString
    }


    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
