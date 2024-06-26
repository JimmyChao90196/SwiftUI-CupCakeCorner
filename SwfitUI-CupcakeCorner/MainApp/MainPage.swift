//
//  MainPage.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/20.
//

import SwiftUI
import Foundation


@Observable
class Order: Codable {
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "address") {
            do {
                let response = try JSONDecoder().decode(String.self, from: savedData)
                streetAddress = response
            } catch {
                print("\(error)")
            }
        }
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type: Int = 0
    var quantity: Int = 3
    
    var specialRequest: Bool = false {
        
        didSet {
            if specialRequest == false {
                addExtrafrosting = false
                addSpinkles = false
            }
        }
    }
    
    var addExtrafrosting: Bool = false
    var addSpinkles: Bool = false
    
    // Delievery detail
    var name = ""
    var streetAddress = "" {
        
        didSet {
            if let dataToBeSaved = try? JSONEncoder().encode(streetAddress) {
                UserDefaults.standard.setValue(dataToBeSaved, forKey: "address")
                return
            }
        }
    }
    
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isReallyEmpty ||
            streetAddress.isReallyEmpty ||
            city.isReallyEmpty ||
            zip.isReallyEmpty {
            return false
        } else {
            return true
        }
    }
    
    // Cost
    var cost: Double {
        var cost: Double = 0
        
        cost += Double(quantity) * 2.0
        
        cost += Double(type) * 0.5
        
        if addExtrafrosting {
            cost += Double(quantity)
        }
        
        if addSpinkles {
            cost += Double(quantity) * 0.5
        }
        
        return cost
    }
    
    enum CodingKeys: CodingKey {
        case _type
        case _quantity
        case _specialRequest
        case _addExtrafrosting
        case _addSpinkles
        case _name
        case _streetAddress
        case _city
        case _zip
        case _$observationRegistrar
    }
}


struct MainPage: View {
    
    //@State private var order = Order()
    @Bindable private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Please select the type", selection: $viewModel.order.type) {
                        ForEach(Order.types.indices, id: \.self) { num in
                            Text("\(Order.types[num])")
                        }
                    }
                    
                    Stepper("Order \(viewModel.order.quantity) cakes", value: $viewModel.order.quantity)
                }
                
                Section {
                    Toggle("Special request", isOn: $viewModel.order.specialRequest)
                    
                    if viewModel.order.specialRequest {
                        Toggle("Add extra topping", isOn: $viewModel.order.addExtrafrosting)
                        Toggle("Add sprinkles", isOn: $viewModel.order.addSpinkles)
                    }
                }
                
                Section {
                    NavigationLink("Order detail") {
                        AddressView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MainPage()
}


