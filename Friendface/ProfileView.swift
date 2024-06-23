//
//  ProfileView.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftData
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        
        let userStr = """
        [
            {
                "id": "50a48fa3-2c0f-4397-ac50-64da464f9954",
                "isActive": false,
                "name": "Alford Rodriguez",
                "age": 21,
                "company": "Imkan",
                "email": "alfordrodriguez@imkan.com",
                "address": "907 Nelson Street, Cotopaxi, South Dakota, 5913",
                "about": "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.",
                "registered": "2015-11-10T01:47:18-00:00",
                "tags": [
                    "cillum",
                    "consequat",
                    "deserunt",
                    "nostrud",
                    "eiusmod",
                    "minim",
                    "tempor"
                ],
                "friends": [
                    {
                        "id": "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0",
                        "name": "Hawkins Patel"
                    }
                ]
            },
            {
                "id": "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0",
                "isActive": true,
                "name": "Hawkins Patel",
                "age": 27,
                "company": "Mazuda",
                "email": "hawkinspatel@mazuda.com",
                "address": "256 Union Avenue, Baker, New Mexico, 518",
                "about": "Consectetur mollit fugiat dolor ea esse reprehenderit enim laboris laboris. Eiusmod consectetur quis cillum tempor veniam deserunt do. Qui ea amet esse qui mollit non non dolor sint consequat ullamco cillum. Sunt aute elit qui elit.",
                "registered": "2016-02-15T08:16:28-00:00",
                "tags": [
                    "minim",
                    "commodo",
                    "do",
                    "aliquip",
                    "elit",
                    "incididunt",
                    "pariatur"
                ],
                "friends": []
            }
        ]
        """
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedUsers = try decoder.decode([User].self, from: Data(userStr.utf8))
        
        for user in decodedUsers {
            container.mainContext.insert(user)
        }
        
        return NavigationStack {
            ProfileView(user: decodedUsers[0], allUsers: decodedUsers)
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
