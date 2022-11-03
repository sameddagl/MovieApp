//
//  Favorite.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 3.11.2022.
//

import Foundation

struct Favorite: MovieCellProtocol{
    let title: String
    let posterPath: String
    let voteAverage: Double
    let genreIDS: [Int]
    
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
}
