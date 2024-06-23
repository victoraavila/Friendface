//
//  ContentView.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\User.isActive, order: .reverse), SortDescriptor(\User.name)]) var users: [User]
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink(value: user) {
                    HStack {
                        Text(user.name)
                        Spacer()
                        Circle()
                            .fill(user.isActive ? Color.green : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .task {
                await downloadData()
            }
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user, allUsers: users)
            }
            .navigationTitle("Friendface")
        }
    }
    
    func downloadData() async {
        guard users.isEmpty else { return }
        
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedUsers = try decoder.decode([User].self, from: data)
            for user in decodedUsers {
                modelContext.insert(user)
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: User.self)
}
