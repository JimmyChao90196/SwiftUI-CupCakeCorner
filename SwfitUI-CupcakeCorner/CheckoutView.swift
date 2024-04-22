//
//  CheckoutView.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/21.
//

import SwiftUI

struct CheckoutView: View {
    
    @State var order: Order
    @State var comfirmationMessage = ""
    @State var alertTitle = ""
    @State var showingAlert = false
    
    let code = Locale.current.currency?.identifier ?? "USD"
    
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
                Text("The total cost is \(order.cost.formatted(.currency(code: "\(code)")))")
                
                // Button
                Button("Checkout") {
                    Task {
                        await placeOrder()
                    }
                }.buttonStyle(BorderedButtonStyle())
            }
        }
        .navigationTitle("Checkout view")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Okay") { }
        } message: {
            Text(comfirmationMessage)
        }

        
    }
    
    // Helper function
    func placeOrder() async {
        
        guard let dataToBeSend = try? JSONEncoder().encode(order) else { return }
    
        var urlRequest = URLRequest(url: URL(string: "https://reqres.in/api/cupcakes")!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // urlRequest.httpMethod = "POST"
        
        
//        do {
//            let (data, metaData) = try await URLSession.shared.upload(for: urlRequest, from: dataToBeSend)
//            
//            if let response = metaData as? HTTPURLResponse {
//                print("\(response.statusCode)")
//            }
//            
//            if let decodedData = try? JSONDecoder().decode(Order.self, from: data) {
//                comfirmationMessage = "\(decodedData.quantity) x \(Order.types[decodedData.type].lowercased()) cake is on it's way"
//                showingAlert = true
//                alertTitle = "Success"
//            }
//        
//        } catch {
//            print(error.localizedDescription)
//            comfirmationMessage = "\(error.localizedDescription)"
//            alertTitle = "Faild"
//            showingAlert = true
//        }
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: dataToBeSend)
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                
                switch statusCode {
                case 200...299:
                    // Successful response
                    if let decodedData = try? JSONDecoder().decode(Order.self, from: data) {
                        comfirmationMessage = "\(decodedData.quantity) x \(Order.types[decodedData.type].lowercased()) cake is on its way"
                        showingAlert = true
                    }
                    print("\(statusCode)")
                case 400...499:
                    // Client error
                    print("Client error with status code: \(statusCode)")
                    // Handle client errors, e.g., show an error message to the user
                case 500...599:
                    // Server error
                    print("Server error with status code: \(statusCode)")
                    // Handle server errors, e.g., show an error message to the user
                default:
                    // Other status codes
                    print("Unexpected status code: \(statusCode)")
                }
            }
        } catch URLError.notConnectedToInternet {
            print("No internet connection")
            comfirmationMessage = "No internet connection\n code \n \(URLError.notConnectedToInternet)"
            alertTitle = "Faild"
            showingAlert = true

            // Handle the case when there is no internet connection
            // You can show an error message to the user or perform any other necessary action
        } catch {
            print(error.localizedDescription)
            // Handle other errors
        }
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
