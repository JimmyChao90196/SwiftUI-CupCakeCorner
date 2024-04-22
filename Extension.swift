//
//  Extension.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/21.
//

import Foundation
import SwiftUI

extension String {
    
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
