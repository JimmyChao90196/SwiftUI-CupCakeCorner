//
//  AddressView.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/22.
//

import SwiftUI


struct AddressView: View {
    
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $viewModel.order.name)
                TextField("StreetAddress", text: $viewModel.order.streetAddress)
                TextField("City", text: $viewModel.order.city)
                TextField("Zip", text: $viewModel.order.zip)
            }
            
            Section {
                NavigationLink("Checkout Details") {
                    CheckoutView(viewModel: viewModel)
                }.disabled(viewModel.order.hasValidAddress == false)
            }
        }
        .navigationTitle("Delivery Detail")
        .navigationBarTitleDisplayMode(.large)
    }
}
