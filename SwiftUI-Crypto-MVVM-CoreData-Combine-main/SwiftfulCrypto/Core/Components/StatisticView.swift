//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            // Enhanced Title with icon
            Text(titleWithIcon)
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 18)
            
            // Enhanced Value
            Text(stat.value)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .frame(height: 24)
            
            // Enhanced Percentage Change
            if let percentageChange = stat.percentageChange {
                HStack(spacing: 2) {
                    Text(percentageEmoji)
                        .font(.system(size: 8))
                    
                    Text(percentageChange.asPercentString())
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                        .foregroundColor(
                            percentageChange >= 0 ? Color.theme.green : Color.theme.red
                        )
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 1)
                .background(
                    Capsule()
                        .fill(
                            (percentageChange >= 0 ? Color.theme.green : Color.theme.red)
                                .opacity(0.1)
                        )
                )
                .frame(height: 14)
            } else {
                Spacer()
                    .frame(height: 14)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70) // Reduced height for 2-row layout
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.9),
                            Color.blue.opacity(0.02)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
        )
    }
    
    private var titleWithIcon: String {
        switch stat.title {
        case "Market Cap":
            return " Market Cap"
        case "24h Volume":
            return " Volume"
        case "BTC Dominance":
            return "₿ BTC Dom"
        case "Portfolio Value":
            return " Portfolio"
        case "24h Change":
            return " 24h Change"
        case "Holdings":
            return " Holdings"
        default:
            return stat.title
        }
    }
    
    private var percentageEmoji: String {
        guard let change = stat.percentageChange else { return "" }
        
        if change >= 5 {
            return "🚀"
        } else if change >= 0 {
            return "📈"
        } else if change >= -5 {
            return "📉"
        } else {
            return "💥"
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Single row preview
            HStack(spacing: 8) {
                StatisticView(stat: dev.stat1)
                StatisticView(stat: dev.stat2)
                StatisticView(stat: dev.stat3)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .previewDisplayName("Single Row")
            
            // Two rows preview
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    StatisticView(stat: dev.stat1)
                    StatisticView(stat: dev.stat2)
                    StatisticView(stat: dev.stat3)
                }
                HStack(spacing: 8) {
                    StatisticView(stat: dev.stat1)
                    StatisticView(stat: dev.stat2)
                    StatisticView(stat: dev.stat3)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .previewDisplayName("Two Rows")
        }
    }
}
