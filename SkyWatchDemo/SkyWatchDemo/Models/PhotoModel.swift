//
//  PhotoModel.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import Foundation

// MARK: - WelcomeElement
struct PhotoModel: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias PhotosModel = [PhotoModel]
