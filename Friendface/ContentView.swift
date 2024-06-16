//
//  ContentView.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Download") {
            Task {
                await downloadData()
            }
        }
    }
    
    func downloadData() async {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedData = try decoder.decode([User].self, from: data)
        } catch {
            print("Error: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
