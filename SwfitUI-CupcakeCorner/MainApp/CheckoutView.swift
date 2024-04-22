//
//  CheckoutView.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/21.
//

import SwiftUI

struct CheckoutView: View {
    
    
    let code = Locale.current.currency?.identifier ?? "USD"
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                
                // Image
                AsyncImage(
                    url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                    scale: 3) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 233)
                    .frame(maxWidth: .infinity).padding()
                
                // Cost
                Text("The total cost is \(viewModel.order.cost.formatted(.currency(code: "\(code)")))")
                
                // Button
                Button("Checkout") {
                    Task {
                        await viewModel.placeOrder()
                    }
                }.buttonStyle(BorderedButtonStyle())
            }
        }
        .navigationTitle("Checkout view")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
            Button("Okay") { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
