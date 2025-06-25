//
//  PreviewProvider.swift
//  Cryptsy
//
//  Created by Arnav Adarsh on 5/05/25
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
//this code hides the keyboard
