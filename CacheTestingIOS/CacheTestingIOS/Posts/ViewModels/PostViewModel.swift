//
//  PostViewModel.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//

import Foundation

struct PostViewModel: Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
}
