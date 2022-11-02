//
//  DetailModel.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import Foundation

// MARK: - Welcome
struct Credits: Codable {
    let id: Int
    let cast, crew: [Cast]
}

// MARK: - Cast
struct Cast: Codable, CastCellProtocol {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment, name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department, job: String?
    
    var posterImage: String?{
        return profilePath
    }
    var nameLabel: String{
        return name
    }

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}
