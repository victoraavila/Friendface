//
//  ProfileView.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    let allUsers: [User]
    
    @ScaledMetric var width: CGFloat = 20
    
    var body: some View {
        Image("profile")
            .resizable()
            .scaledToFit()
            .padding(.bottom)
        
        VStack(alignment: .leading) {
            Text(user.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.blue)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "bag.fill")
                        .frame(width: width, alignment: .center)
                    Text("Works at \(user.company)")
                }
                HStack {
                    Image(systemName: "birthday.cake.fill")
                        .frame(width: width, alignment: .center)
                    Text("\(user.age) years old")
                }
                HStack {
                    Image(systemName: "star.fill")
                        .frame(width: width, alignment: .center)
                    Text("Created on \(user.registered.formatted(.dateTime.month().year()))")
                }
                
                CustomDividerView()
                
                Text("Friends")
                    .font(.title.bold())
                    .padding(.bottom, 5) // So it stays 5 points away of the thing below it
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(user.friends) { friend in
                        if let friendUser = getUserById(friend.id) {
                            NavigationLink(destination: ProfileView(user: friendUser, allUsers: allUsers)) {
                                ZStack {
                                    Circle()
                                        .frame(width: 100)
                                        .clipShape(.capsule)
                                        .foregroundStyle(.tertiary)
                                        .overlay( // To draw something over it
                                            Capsule()
                                                .strokeBorder(.blue, lineWidth: 3)
                                        )
                                    
                                    Text(friend.name.components(separatedBy: " ").joined(separator: "\n"))
                                        .frame(alignment: .center)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
    
    func getUserById(_ id: UUID) -> User? {
        return allUsers.first { $0.id == id }
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var users: [User] = []
    
    var body: some View {
        Group {
            if let firstUser = users.first {
                ProfileView(user: firstUser, allUsers: users)
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
            DispatchQueue.main.async {
                self.users = users
            }
        } catch {
            print("Preview Error: \(error)")
        }
    }
}
