//
//  NetworkManager.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/22.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case unexpectedError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // Request
    var urlRequest: URLRequest {
        
        var urlRequest = URLRequest(url: URL(string: "https://reqres.in/api/cupcakes")!)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "POST"
        
        return urlRequest
    }
    
    
    // Fetching data
    func makingNetworkCall<T: Codable>(inputData: T) async -> Result<T, Error> {
        
        do {
            let dataToBeSend = try JSONEncoder().encode(inputData)
            
            let (data, _) = try await URLSession.shared.upload(
                for: urlRequest,
                from: dataToBeSend)
            
            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                return .success(decodedData)
            }
            
        } catch {
            return .failure(error)
        }
        
        return .failure(NetworkError.unexpectedError)
    }
    
    // Handeling error in details
//    func placeOrder() async {
//
//        guard let dataToBeSend = try? JSONEncoder().encode(order) else { return }
//
//        var urlRequest = URLRequest(url: URL(string: "https://reqres.in/api/cupcakes")!)
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.httpMethod = "POST"
//
//        do {
//            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: dataToBeSend)
//
//            if let httpResponse = response as? HTTPURLResponse {
//                let statusCode = httpResponse.statusCode
//
//                switch statusCode {
//                case 200...299:
//                    // Successful response
//                    if let decodedData = try? JSONDecoder().decode(Order.self, from: data) {
//                        alertMessage = "\(decodedData.quantity) x \(Order.types[decodedData.type].lowercased()) cake is on its way"
//                        showingAlert = true
//                    }
//                    print("\(statusCode)")
//                case 400...499:
//                    // Client error
//                    print("Client error with status code: \(statusCode)")
//                    // Handle client errors, e.g., show an error message to the user
//                case 500...599:
//                    // Server error
//                    print("Server error with status code: \(statusCode)")
//                    // Handle server errors, e.g., show an error message to the user
//                default:
//                    // Other status codes
//                    print("Unexpected status code: \(statusCode)")
//                }
//            }
//        } catch URLError.notConnectedToInternet {
//            print("No internet connection")
//            alertMessage = "No internet connection\n code \n \(URLError.notConnectedToInternet)"
//            alertTitle = "Faild"
//            showingAlert = true
//
//        } catch {
//            print(error.localizedDescription)
//            // Handle other errors
//        }
//    }
}
