//
//  ContentView.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/18.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    
    @State var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { result in
            VStack(alignment: .leading) {
                Text("\(result.trackName)")
                    .font(.headline)
                Text("\(result.collectionName)")
            }
        }.task {
            await loadData()
        }
    }
    
    // Load data function
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid data")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try? JSONDecoder().decode(Response.self, from: data)
            if let response {
                results = response.results
            }
            
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}
