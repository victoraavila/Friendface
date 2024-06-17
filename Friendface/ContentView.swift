//
//  ContentView.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    
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
                ProfileView(user: user)
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
            
            users = try decoder.decode([User].self, from: data)
            sortUsers()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func sortUsers() {
        users.sort { user1, user2 in
            if user1.isActive != user2.isActive {
                return user1.isActive ? true : false
            } else {
                return user1.name < user2.name
            }
        }
    }
}

#Preview {
    ContentView()
}
