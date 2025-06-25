//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//
import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if showPortfolio {
                // Show Portfolio Stats with custom layout
                PortfolioStatsView()
                    .environmentObject(vm)
            } else {
                // Show Market Stats with new layout
                MarketStatsView()
                    .environmentObject(vm)
            }
        }
    }
}

// MARK: - Market Stats View (Updated Layout)
struct MarketStatsView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    // Market data properties - using existing vm.statistics
    private var totalMarketCap: String {
        vm.statistics.first(where: { $0.title.contains("Market Cap") })?.value ?? "$2.5T"
    }
    
    private var marketCapChange: String {
        vm.statistics.first(where: { $0.title.contains("Market Cap") })?.percentageChange?.asPercentString() ?? "+2.5%"
    }
    
    private var marketCapChangeValue: Double {
        vm.statistics.first(where: { $0.title.contains("Market Cap") })?.percentageChange ?? 0
    }
    
    private var totalVolume: String {
        vm.statistics.first(where: { $0.title.contains("Volume") })?.value ?? "$85.2B"
    }
    
    private var btcDominance: String {
        vm.statistics.first(where: { $0.title.contains("BTC") })?.value ?? "42.8%"
    }
    
    private var btcDominanceChange: Double {
        vm.statistics.first(where: { $0.title.contains("BTC") })?.percentageChange ?? 0
    }
    
    private var bestPerformingCoin: CoinModel? {
        vm.allCoins.max { coin1, coin2 in
            (coin1.priceChangePercentage24H ?? 0) < (coin2.priceChangePercentage24H ?? 0)
        }
    }
    
    var body: some View {
        // Center both horizontally AND vertically
        VStack {
            Spacer() // Top spacer for vertical centering
            
            HStack {
                Spacer() // Left spacer for horizontal centering
                
                VStack(spacing: 28) {
                    // First Row: Global Market Cap (centered)
                    marketCapCard
                        .frame(height: 90)
                        .frame(maxWidth: 350) // Fixed max width for centering
                    
                    // Second Row: Three cards centered as a group
                    HStack(spacing: 12) {
                        // 24h Volume
                        volumeCard
                            .frame(width: 100) // Fixed width for symmetry
                            .frame(height: 90)
                        
                        // Top Gainer
                        bestPerformingCard
                            .frame(width: 100) // Fixed width for symmetry
                            .frame(height: 90)
                        
                        // BTC Dominance
                        btcDominanceCard
                            .frame(width: 100) // Fixed width for symmetry
                            .frame(height: 90)
                    }
                    .frame(maxWidth: 350) // Match top card width
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                
                Spacer() // Right spacer for horizontal centering
            }
            
            Spacer() // Bottom spacer for vertical centering
        }
        .background(marketStatsBackground)
    }
    
    // MARK: - Market Cards
    
    private var marketCapCard: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Global Market Cap")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                Spacer()
            }
            
            HStack {
                Text(totalMarketCap)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                Spacer()
            }
            
            HStack {
                HStack(spacing: 4) {
                    Text(marketCapChangeValue >= 0 ? "📈" : "📉")
                        .font(.system(size: 12))
                    
                    Text(marketCapChange)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(
                            marketCapChangeValue >= 0 ? Color.theme.green : Color.theme.red
                        )
                    
                    Text("24h Change")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(
                            (marketCapChangeValue >= 0 ? Color.theme.green : Color.theme.red)
                                .opacity(0.1)
                        )
                )
                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(marketCardBackground)
    }
    
    private var volumeCard: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                Text("24h Volume")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(totalVolume)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text("Global")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(marketCardBackground)
    }
    
    private var btcDominanceCard: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                Text("BTC Dom.")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(btcDominance)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                if btcDominanceChange != 0 {
                    Text(btcDominanceChange.asPercentString())
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(
                            btcDominanceChange >= 0 ? Color.theme.green : Color.theme.red
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("--")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(marketCardBackground)
    }
    
    private var bestPerformingCard: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                Text("Top Gainer")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            if let coin = bestPerformingCoin {
                VStack(spacing: 2) {
                    Text(coin.symbol.uppercased())
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                    
                    Text((coin.priceChangePercentage24H ?? 0).asPercentString())
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(Color.theme.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                VStack(spacing: 2) {
                    Text("N/A")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("--")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(marketCardBackground)
    }
    
    // MARK: - Background Style
    
    private var marketStatsBackground: some View {
        RoundedRectangle(cornerRadius: 24)
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
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.15),
                                Color.purple.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
    }
    
    private var marketCardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.95),
                        Color.blue.opacity(0.02)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.1), lineWidth: 0.8)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Portfolio Stats View (Updated Layout)
//struct PortfolioStatsView: View {
//    @EnvironmentObject private var vm: HomeViewModel
//    
//    // Mock portfolio data
//    private var portfolioValue: String {
//        "$12,345.67"
//    }
//    
//    private var portfolioChangePercentage: Double {
//        2.5
//    }
//    
//    private var totalCoins: String {
//        "5"
//    }
//    
//    private var totalInvestment: String {
//        "$10,000.00"
//    }
//    
//    private var totalProfit: String {
//        "$2,345.67"
//    }
//    
//    private var totalProfitPercentage: Double {
//        23.46
//    }
//    
//    private var dayChange: String {
//        "$45.23"
//    }
//    
//    private var dayChangePercentage: Double {
//        0.37
//    }
//    
//    var body: some View {
//        // Center both horizontally AND vertically
//        VStack {
//            Spacer() // Top spacer for vertical centering
//            
//            HStack {
//                Spacer() // Left spacer for horizontal centering
//                
//                VStack(spacing: 28) {
//                    // First Row: Portfolio Value (centered)
//                    portfolioValueCard
//                        .frame(height: 90)
//                        .frame(maxWidth: 350) // Fixed max width for centering
//                    
//                    // Second Row: Three cards centered as a group
//                    HStack(spacing: 12) {
//                        // Total Investment
//                        totalInvestmentCard
//                            .frame(width: 100) // Fixed width for symmetry
//                            .frame(height: 90)
//                        
//                        // Total Profit
//                        totalProfitCard
//                            .frame(width: 100) // Fixed width for symmetry
//                            .frame(height: 90)
//                        
//                        // 24hr Change
//                        dayChangeCard
//                            .frame(width: 100) // Fixed width for symmetry
//                            .frame(height: 90)
//                    }
//                    .frame(maxWidth: 350) // Match top card width
//                }
//                .padding(.horizontal, 20)
//                .padding(.vertical, 24)
//                
//                Spacer() // Right spacer for horizontal centering
//            }
//            
//            Spacer() // Bottom spacer for vertical centering
//        }
//        .background(portfolioStatsBackground)
//    }
//    
//    // MARK: - Portfolio Cards
//    
//    private var portfolioValueCard: some View {
//        VStack(spacing: 10) {
//            HStack {
//                Text("Portfolio Value")
//                    .font(.system(size: 16, weight: .semibold, design: .rounded))
//                    .foregroundColor(Color.theme.secondaryText)
//                Spacer()
//            }
//            
//            HStack {
//                Text(portfolioValue)
//                    .font(.system(size: 24, weight: .bold, design: .rounded))
//                    .foregroundColor(Color.theme.accent)
//                Spacer()
//            }
//            
//            HStack {
//                HStack(spacing: 4) {
//                    Text(portfolioChangePercentage >= 0 ? "📈" : "📉")
//                        .font(.system(size: 12))
//                    
//                    Text(portfolioChangePercentage.asPercentString())
//                        .font(.system(size: 14, weight: .bold, design: .rounded))
//                        .foregroundColor(
//                            portfolioChangePercentage >= 0 ? Color.theme.green : Color.theme.red
//                        )
//                    
//                    Text("Total Return")
//                        .font(.system(size: 12, weight: .medium, design: .rounded))
//                        .foregroundColor(Color.theme.secondaryText)
//                }
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(
//                    Capsule()
//                        .fill(
//                            (portfolioChangePercentage >= 0 ? Color.theme.green : Color.theme.red)
//                                .opacity(0.1)
//                        )
//                )
//                Spacer()
//            }
//        }
//        .padding(.horizontal, 18)
//        .padding(.vertical, 14)
//        .background(portfolioCardBackground)
//    }
//    
//    private var totalInvestmentCard: some View {
//        VStack(spacing: 6) {
//            VStack(spacing: 4) {
//                Text("Investment")
//                    .font(.system(size: 10, weight: .semibold, design: .rounded))
//                    .foregroundColor(Color.theme.secondaryText)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            
//            Spacer()
//            
//            VStack(spacing: 2) {
//                Text(totalInvestment)
//                    .font(.system(size: 13, weight: .bold, design: .rounded))
//                    .foregroundColor(Color.theme.accent)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .minimumScaleFactor(0.5)
//                    .lineLimit(1)
//                
//                Text("\(totalCoins) coins")
//                    .font(.system(size: 9, weight: .medium, design: .rounded))
//                    .foregroundColor(Color.theme.secondaryText)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 12)
//        .background(portfolioCardBackground)
//    }
//    
//    private var totalProfitCard: some View {
//        VStack(spacing: 6) {
//            VStack(spacing: 4) {
//                Text("Profit/Loss")
//                    .font(.system(size: 10, weight: .semibold, design: .rounded))
//                    .foregroundColor(Color.theme.secondaryText)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            
//            Spacer()
//            
//            VStack(spacing: 2) {
//                Text(totalProfit)
//                    .font(.system(size: 13, weight: .bold, design: .rounded))
//                    .foregroundColor(
//                        totalProfitPercentage >= 0 ? Color.theme.green : Color.theme.red
//                    )
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .minimumScaleFactor(0.5)
//                    .lineLimit(1)
//                
//                Text(totalProfitPercentage.asPercentString())
//                    .font(.system(size: 9, weight: .bold, design: .rounded))
//                    .foregroundColor(
//                        totalProfitPercentage >= 0 ? Color.theme.green : Color.theme.red
//                    )
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 12)
//        .background(portfolioCardBackground)
//    }
//    
//    private var dayChangeCard: some View {
//        VStack(spacing: 6) {
//            VStack(spacing: 4) {
//                Text("24h Change")
//                    .font(.system(size: 10, weight: .semibold, design: .rounded))
//                    .foregroundColor(Color.theme.secondaryText)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            
//            Spacer()
//            
//            VStack(spacing: 2) {
//                Text(dayChange)
//                    .font(.system(size: 13, weight: .bold, design: .rounded))
//                    .foregroundColor(
//                        dayChangePercentage >= 0 ? Color.theme.green : Color.theme.red
//                    )
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .minimumScaleFactor(0.5)
//                    .lineLimit(1)
//                
//                Text(dayChangePercentage.asPercentString())
//                    .font(.system(size: 9, weight: .bold, design: .rounded))
//                    .foregroundColor(
//                        dayChangePercentage >= 0 ? Color.theme.green : Color.theme.red
//                    )
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 12)
//        .background(portfolioCardBackground)
//    }
//    
//    // MARK: - Background Styles
//    
//    private var portfolioStatsBackground: some View {
//        RoundedRectangle(cornerRadius: 24)
//            .fill(
//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color.white,
//                        Color.purple.opacity(0.02)
//                    ]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 24)
//                    .stroke(
//                        LinearGradient(
//                            gradient: Gradient(colors: [
//                                Color.purple.opacity(0.15),
//                                Color.blue.opacity(0.1)
//                            ]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        ),
//                        lineWidth: 1
//                    )
//            )
//            .shadow(color: Color.purple.opacity(0.08), radius: 20, x: 0, y: 10)
//    }
//    
//    private var portfolioCardBackground: some View {
//        RoundedRectangle(cornerRadius: 16)
//            .fill(
//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color.white.opacity(0.95),
//                        Color.purple.opacity(0.02)
//                    ]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.purple.opacity(0.1), lineWidth: 0.8)
//            )
//            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
//    }
//}
//
//struct HomeStatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HomeStatsView(showPortfolio: .constant(false))
//                .environmentObject(dev.homeVM)
//                .padding()
//                .previewDisplayName("Market Stats")
//            
//            HomeStatsView(showPortfolio: .constant(true))
//                .environmentObject(dev.homeVM)
//                .padding()
//                .previewDisplayName("Portfolio Stats")
//        }
//        .background(Color.gray.opacity(0.1))
//    }
//}
// MARK: - Portfolio Stats View (Updated Layout)
struct PortfolioStatsView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    // REAL portfolio data from HomeViewModel ✅
    private var portfolioValue: String {
        let value = vm.portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        return value.asCurrencyWith2Decimals()
    }
    
    private var portfolioChangePercentage: Double {
        let currentValue = vm.portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        let previousValue = vm.portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            return currentValue / (1 + percentChange)
        }.reduce(0, +)
        
        return previousValue > 0 ? ((currentValue - previousValue) / previousValue) * 100 : 0
    }
    
    private var totalCoins: String {
        "\(vm.portfolioCoins.count)"
    }
    
    private var totalInvestment: String {
        // Calculate investment based on current value minus gains
        let currentValue = vm.portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        let changePercent = portfolioChangePercentage / 100
        let investment = currentValue / (1 + changePercent)
        return investment.asCurrencyWith2Decimals()
    }
    
    private var totalProfit: String {
        let currentValue = vm.portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        let previousValue = vm.portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            return currentValue / (1 + percentChange)
        }.reduce(0, +)
        
        return (currentValue - previousValue).asCurrencyWith2Decimals()
    }
    
    private var totalProfitPercentage: Double {
        portfolioChangePercentage
    }
    
    private var dayChange: String {
        let dayChange = vm.portfolioCoins.map { coin -> Double in
            let holdings = coin.currentHoldings ?? 0
            let priceChange24h = coin.priceChange24H ?? 0
            return holdings * priceChange24h
        }.reduce(0, +)
        
        return dayChange.asCurrencyWith2Decimals()
    }
    
    private var dayChangePercentage: Double {
        let currentValue = vm.portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        let dayChange = vm.portfolioCoins.map { coin -> Double in
            let holdings = coin.currentHoldings ?? 0
            let priceChange24h = coin.priceChange24H ?? 0
            return holdings * priceChange24h
        }.reduce(0, +)
        
        return currentValue > 0 ? (dayChange / currentValue) * 100 : 0
    }
    
    var body: some View {
        // Center both horizontally AND vertically
        VStack {
            Spacer() // Top spacer for vertical centering
            
            HStack {
                Spacer() // Left spacer for horizontal centering
                
                VStack(spacing: 28) {
                    // First Row: Portfolio Value (centered)
                    portfolioValueCard
                        .frame(height: 90)
                        .frame(maxWidth: 350) // Fixed max width for centering
                    
                    // Second Row: Three cards centered as a group
                    HStack(spacing: 12) {
                        // Total Investment
                        totalInvestmentCard
                            .frame(width: 100) // Fixed width for symmetry
                            .frame(height: 90)
                        
                        // Total Profit
                        totalProfitCard
                            .frame(width: 100) // Fixed width for symmetry
                            .frame(height: 90)
                        
                        // 24hr Change
                        dayChangeCard
                            .frame(width: 100) // Fixed width for symmetry
                            .frame(height: 90)
                    }
                    .frame(maxWidth: 350) // Match top card width
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                
                Spacer() // Right spacer for horizontal centering
            }
            
            Spacer() // Bottom spacer for vertical centering
        }
        .background(portfolioStatsBackground)
    }
    
    // MARK: - Portfolio Cards
    
    private var portfolioValueCard: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Portfolio Value")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                Spacer()
            }
            
            HStack {
                Text(portfolioValue)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                Spacer()
            }
            
            HStack {
                HStack(spacing: 4) {
                    Text(portfolioChangePercentage >= 0 ? "📈" : "📉")
                        .font(.system(size: 12))
                    
                    Text(portfolioChangePercentage.asPercentString())
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(
                            portfolioChangePercentage >= 0 ? Color.theme.green : Color.theme.red
                        )
                    
                    Text("Total Return")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(
                            (portfolioChangePercentage >= 0 ? Color.theme.green : Color.theme.red)
                                .opacity(0.1)
                        )
                )
                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(portfolioCardBackground)
    }
    
    private var totalInvestmentCard: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                Text("Investment")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(totalInvestment)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text("\(totalCoins) coins")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(portfolioCardBackground)
    }
    
    private var totalProfitCard: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                Text("Profit/Loss")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(totalProfit)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(
                        totalProfitPercentage >= 0 ? Color.theme.green : Color.theme.red
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text(totalProfitPercentage.asPercentString())
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(
                        totalProfitPercentage >= 0 ? Color.theme.green : Color.theme.red
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(portfolioCardBackground)
    }
    
    private var dayChangeCard: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                Text("24h Change")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(dayChange)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(
                        dayChangePercentage >= 0 ? Color.theme.green : Color.theme.red
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text(dayChangePercentage.asPercentString())
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(
                        dayChangePercentage >= 0 ? Color.theme.green : Color.theme.red
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(portfolioCardBackground)
    }
    
    // MARK: - Background Styles
    
    private var portfolioStatsBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color.purple.opacity(0.02)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.15),
                                Color.blue.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.purple.opacity(0.08), radius: 20, x: 0, y: 10)
    }
    
    private var portfolioCardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.95),
                        Color.purple.opacity(0.02)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.1), lineWidth: 0.8)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
