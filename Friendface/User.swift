//
//  User.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import Foundation
import SwiftData

struct User: Identifiable, Codable {
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
}
