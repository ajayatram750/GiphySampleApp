//
//  GiphyResponseModel.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import Foundation

public struct GiphyResponseModel: Codable {
    
    let gifsData: [GiphyImages]
    let paginationData: pagination
    
    /// Override the property name to match the respective JSON field name
        enum CodingKeys : String, CodingKey {
            case gifsData = "data"
            case paginationData = "pagination"
        }
}

struct GiphyImages: Codable {
    let id:String
    let url: String
    let title : String
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case url = "url"
        case title = "title"
    }
}

struct pagination: Codable {
    let count: Int
    let offset: Int
    
    enum CodingKeys : String, CodingKey {
        case count = "count"
        case offset = "offset"
    }
}
