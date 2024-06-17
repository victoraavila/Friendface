//
//  ProfileView.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    
    var body: some View {
        Text(user.name)
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var user: User?
    
    var body: some View {
        Group {
            if let user = user {
                ProfileView(user: user)
            } else {
                ProgressView()
            }
        }
        .task {
            await loadPreviewData()
        }
    }
    
    private func loadPreviewData() async {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let users = try decoder.decode([User].self, from: data)
            if let firstUser = users.first {
                user = firstUser
            }
        } catch {
            print("Preview Error: \(error)")
        }
    }
}
