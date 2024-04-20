//
//  LoadingImage.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/18.
//

import SwiftUI

struct LoadingImage: View {
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100, alignment: .center)
            
            
            AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
                
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(let error):
                    Text("\(error)")
                    
                default:
                    ProgressView()
                }
            }
            
        }
    }
}

#Preview {
    LoadingImage()
}
