//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//
import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            
            if showHoldingsColumn {
                centerColumn
            }
            
            rightColumn
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.blue.opacity(0.02)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.1),
                                    Color.purple.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
        )
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 16) {
            // Enhanced Rank Badge
            Text("\(coin.rank)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.8),
                                    Color.purple.opacity(0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                )
            
            // Enhanced Coin Image
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                CoinImageView(coin: coin)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            }
            
            // Enhanced Coin Info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(coin.symbol.uppercased())
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color.theme.accent)
                        .lineLimit(1)
                    
                    // Enhanced trending indicator
                    if let change = coin.priceChangePercentage24H, abs(change) > 10 {
                        Text(change > 0 ? "🔥" : "⚡")
                            .font(.system(size: 14))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(change > 0 ? Color.orange.opacity(0.1) : Color.purple.opacity(0.1))
                            )
                    }
                }
                
                Text(coin.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing, spacing: 6) {
            // Enhanced Holdings Value
            HStack(spacing: 6) {
                Text("💼")
                    .font(.system(size: 12))
                
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                    .lineLimit(1)
            }
            
            // Enhanced Holdings Amount
            Text((coin.currentHoldings ?? 0).asNumberString())
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.blue.opacity(0.08))
                        .overlay(
                            Capsule()
                                .stroke(Color.blue.opacity(0.2), lineWidth: 0.5)
                        )
                )
                .lineLimit(1)
        }
        .padding(.trailing, 12)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // Enhanced Price
            HStack(spacing: 2) {
                Text("$")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(coin.currentPrice.asCurrencyWith6Decimals().dropFirst())
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                    .lineLimit(1)
            }
            
            // Enhanced percentage change with premium styling
            HStack(spacing: 8) {
                Text(percentageEmoji)
                    .font(.system(size: 16))
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.00%")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(percentageChangeColor)
                        .lineLimit(1)
                    
                    Text(performanceLabel)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(percentageChangeColor.opacity(0.8))
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(percentageChangeColor.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(percentageChangeColor.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .frame(width: 110, alignment: .trailing)
    }
    
    // Helper computed properties
    private var percentageChangeColor: Color {
        let change = coin.priceChangePercentage24H ?? 0
        return change >= 0 ? Color.theme.green : Color.theme.red
    }
    
    private var percentageEmoji: String {
        let change = coin.priceChangePercentage24H ?? 0
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
    
    private var performanceLabel: String {
        let change = coin.priceChangePercentage24H ?? 0
        if change >= 10 {
            return "ROCKET"
        } else if change >= 5 {
            return "STRONG"
        } else if change >= 2 {
            return "GOOD"
        } else if change >= 0 {
            return "GAIN"
        } else if change >= -2 {
            return "DIP"
        } else if change >= -5 {
            return "DOWN"
        } else {
            return "CRASH"
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 12) {
                CoinRowView(coin: dev.coin, showHoldingsColumn: false)
                CoinRowView(coin: dev.coin, showHoldingsColumn: true)
            }
            .padding()
            .background(Color.theme.background)
            .previewLayout(.sizeThatFits)
        }
    }
}
