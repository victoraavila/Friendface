//
//  Friend.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import Foundation
import SwiftData

@Model
class Friend: Identifiable, Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id: UUID
    var name: String
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let strId = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: strId) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
}
