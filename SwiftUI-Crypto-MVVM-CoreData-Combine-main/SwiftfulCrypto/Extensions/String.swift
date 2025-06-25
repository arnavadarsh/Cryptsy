//
//  PreviewProvider.swift
//  Cryptsy
//
//  Created by Arnav Adarsh on 5/05/25
//
import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
