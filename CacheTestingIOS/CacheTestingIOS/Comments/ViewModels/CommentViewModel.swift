//
//  CommentViewModel.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 26.04.2022.
//

import Foundation

struct CommentViewModel: Hashable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CommentViewModel, rhs: CommentViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
