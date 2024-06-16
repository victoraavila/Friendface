//
//  Friend.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import Foundation
import SwiftData

struct Friend: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id: UUID
    var name: String
}
