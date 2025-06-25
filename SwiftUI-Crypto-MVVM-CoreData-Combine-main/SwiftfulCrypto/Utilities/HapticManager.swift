//
//  PreviewProvider.swift
//  Cryptsy
//
//  Created by Arnav Adarsh on 5/05/25
//
import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
