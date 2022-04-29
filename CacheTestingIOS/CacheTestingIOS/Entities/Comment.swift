//
//  Comment.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 25.04.2022.
//

import Foundation

struct Comment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}
