//
//  UsersModel.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import Foundation
import UIKit

typealias UsersModel = [UserModel]

// MARK: - WelcomeElement
struct UserModel: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
    var imageName: String?
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
