//
//  User.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
    
    // Implementing Equatable
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    // Implementing Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
