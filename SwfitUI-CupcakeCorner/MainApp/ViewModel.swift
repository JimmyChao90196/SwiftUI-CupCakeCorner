//
//  ViewModel.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/22.
//

import Foundation
import SwiftUI

@Observable
class ViewModel {
    
    private let networkManager = NetworkManager.shared
    
    // Observing properties
    var order = Order()
    private(set) var alertMessage = ""
    private(set) var alertTitle = ""
    var showingAlert = false
    
    // Place order
    func placeOrder() async {
        let result = await networkManager.makingNetworkCall(inputData: order)
        
        switch result {
        case .success(let decodedData):
            alertMessage = "\(decodedData.quantity) x \(Order.types[decodedData.type].lowercased()) cake is on its way"
            alertTitle = "Successful"
            showingAlert = true
        case .failure(let error):
            alertMessage =
            """
            Error message: [\(error.localizedDescription)]
            """
            alertTitle = "Failed"
            showingAlert = true
        }
    }
}

