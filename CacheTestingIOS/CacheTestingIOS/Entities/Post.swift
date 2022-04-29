//
//  Post.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
