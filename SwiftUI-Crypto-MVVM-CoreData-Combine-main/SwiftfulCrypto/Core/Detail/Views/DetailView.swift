//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    @EnvironmentObject private var homeVM: HomeViewModel
    @State private var showFullDescription: Bool = false
    @State private var selectedTab: Int = 0
    @State private var showBuySheet: Bool = false
    @State private var showSellSheet: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 16
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.05),
                    Color.theme.background,
                    Color.purple.opacity(0.02)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Enhanced Header Section
                    headerSection
                        .padding(.top, 20)
                    
                    // Buy/Sell Action Buttons
                    buyAndSellButtons
                    
                    // Chart Section
                    modernSection(
                        title: "Price Chart",
                        content: ChartView(coin: vm.coin)
                    )
                    
                    // Tab Selector
                    tabSelector
                        .padding(.horizontal, 20)
                    
                    // Content based on selected tab
                    if selectedTab == 0 {
                        // Overview Content
                        if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                            modernSection(
                                title: "Description",
                                content: enhancedDescriptionSection
                            )
                        }
                        
                        modernSection(
                            title: "Overview Statistics",
                            content: enhancedOverviewGrid
                        )
                    } else if selectedTab == 1 {
                        // Details Content
                        modernSection(
                            title: "Additional Details",
                            content: enhancedAdditionalGrid
                        )
                        
                        modernSection(
                            title: "External Links",
                            content: enhancedWebsiteSection
                        )
                    } else {
                        // Analysis Content
                        modernSection(
                            title: "Market Analysis",
                            content: marketAnalysisSection
                        )
                        
                        modernSection(
                            title: "Risk Assessment",
                            content: riskAssessmentSection
                        )
                    }
                    
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showBuySheet) {
            if #available(iOS 15.0, *) {
                BuyCoinDetailView(coin: vm.coin, homeVM: homeVM)
            } else {
                // Fallback on earlier versions
            }
        }
        .sheet(isPresented: $showSellSheet) {
            if #available(iOS 15.0, *) {
                SellCoinDetailView(coin: vm.coin, homeVM: homeVM)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension DetailView {
    
    private var buyAndSellButtons: some View {
        HStack(spacing: 16) {
            // Buy Button
            Button(action: {
                showBuySheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Buy \(vm.coin.symbol.uppercased())")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.theme.green, Color.green]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
            }
            
            // Sell Button (only if user has holdings)
            if homeVM.portfolioCoins.contains(where: { $0.id == vm.coin.id }) {
                Button(action: {
                    showSellSheet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("Sell \(vm.coin.symbol.uppercased())")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.theme.red, Color.red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                }
            } else {
                // Placeholder to maintain layout when no holdings
                Button(action: {
                    showBuySheet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("No Holdings")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        Color.gray.opacity(0.2)
                    )
                    .cornerRadius(25)
                }
                .disabled(true)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func modernSection<Content: View>(title: String, content: Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.top, 4)
            
            content
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
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
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.1),
                                    Color.purple.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Back button and coin info
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                }
                
                Spacer()
                
                // Holdings indicator if user owns this coin
                if let portfolioCoin = homeVM.portfolioCoins.first(where: { $0.id == vm.coin.id }),
                   let holdings = portfolioCoin.currentHoldings {
                    VStack(spacing: 2) {
                        Text("Your Holdings")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Text("\(holdings.asNumberString()) \(vm.coin.symbol.uppercased())")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.theme.accent)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
                }
            }
            
            // Enhanced coin header - Centered
            VStack(spacing: 16) {
                // Coin image with enhanced styling - Centered
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    CoinImageView(coin: vm.coin)
                        .frame(width: 60, height: 60)
                }
                .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 5)
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 12) {
                    // Coin name and symbol - Centered
                    VStack(spacing: 8) {
                        Text(vm.coin.name)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color.theme.accent)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        
                        HStack(spacing: 12) {
                            Text(vm.coin.symbol.uppercased())
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.blue)
                                )
                            
                            if let rank = vm.coin.marketCapRank {
                                Text("#\(rank)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color.orange)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.orange.opacity(0.1))
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Current price - Centered (Convert to USD format)
                    VStack(spacing: 8) {
                        Text((vm.coin.currentPrice.asCurrencyWith6Decimals()).replacingOccurrences(of: "$", with: "$"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.theme.accent)
                            .frame(maxWidth: .infinity)
                        
                        if let priceChange = vm.coin.priceChangePercentage24H {
                            HStack(spacing: 6) {
                                Image(systemName: priceChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.system(size: 12, weight: .bold))
                                
                                Text(priceChange.asPercentString())
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(priceChange >= 0 ? Color.theme.green : Color.theme.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill((priceChange >= 0 ? Color.theme.green : Color.theme.red).opacity(0.1))
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.blue.opacity(0.03)
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
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        )
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tabTitle(for: index))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(selectedTab == index ? .white : Color.theme.secondaryText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedTab == index ?
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ).opacity(1) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.clear]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ).opacity(1)
                            )
                            .clipShape(Capsule())
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Overview"
        case 1: return "Details"
        case 2: return "Analysis"
        default: return "Overview"
        }
    }
    
    private var enhancedDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let coinDescription = vm.coinDescription {
                Text(coinDescription)
                    .lineLimit(showFullDescription ? nil : 4)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFullDescription.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Text(showFullDescription ? "Show Less" : "Read More")
                            .font(.system(size: 14, weight: .bold))
                        
                        Image(systemName: showFullDescription ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var enhancedOverviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: spacing,
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    enhancedStatisticView(stat: stat)
                }
            }
        )
        .padding(.horizontal, 20)
    }
    
    private var enhancedAdditionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: spacing,
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    enhancedStatisticView(stat: stat)
                }
            }
        )
        .padding(.horizontal, 20)
    }
    
    private func enhancedStatisticView(stat: StatisticModel) -> some View {
        VStack(spacing: 8) {
            Text(stat.title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            // Convert currency values from rupee to dollar
            Text(stat.value.replacingOccurrences(of: "$", with: "$"))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
            
            if let percentageChange = stat.percentageChange {
                HStack(spacing: 4) {
                    Image(systemName: percentageChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10, weight: .bold))
                    
                    Text(percentageChange.asPercentString())
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(percentageChange >= 0 ? Color.theme.green : Color.theme.red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill((percentageChange >= 0 ? Color.theme.green : Color.theme.red).opacity(0.1))
                )
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }
    
    private var enhancedWebsiteSection: some View {
        VStack(spacing: 16) {
            if let websiteString = vm.websiteURL, let url = URL(string: websiteString) {
                modernLinkButton(
                    title: "Official Website",
                    subtitle: "Visit the official website",
                    url: url
                )
            }
            
            if let redditString = vm.redditURL, let url = URL(string: redditString) {
                modernLinkButton(
                    title: "Reddit Community",
                    subtitle: "Join the discussion",
                    url: url
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func modernLinkButton(title: String, subtitle: String, url: URL) -> some View {
        Link(destination: url) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity)
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.blue)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var marketAnalysisSection: some View {
        VStack(spacing: 16) {
            analysisCard(
                title: "Trend Analysis",
                value: "Bullish",
                description: "Strong upward momentum",
                color: Color.green
            )
            
            analysisCard(
                title: "Market Strength",
                value: "Strong",
                description: "High trading volume",
                color: Color.blue
            )
            
            analysisCard(
                title: "Recommendation",
                value: "Hold",
                description: "Based on technical analysis",
                color: Color.orange
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var riskAssessmentSection: some View {
        VStack(spacing: 16) {
            riskCard(
                level: "Medium",
                description: "Moderate volatility expected",
                color: Color.orange
            )
            
            VStack(spacing: 12) {
                Text("Risk Factors:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    riskFactor(text: "Market volatility")
                    riskFactor(text: "Regulatory changes")
                    riskFactor(text: "Technology risks")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.yellow.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Helper Methods
    
    private func analysisCard(title: String, value: String, description: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .frame(maxWidth: .infinity)
            
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(Color.theme.secondaryText)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }
    
    private func riskCard(level: String, description: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text("Risk Level")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity)
            
            Text(level)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .frame(maxWidth: .infinity)
            
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(Color.theme.secondaryText)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }
    
    private func riskFactor(text: String) -> some View {
        Text("• \(text)")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color.theme.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Keyboard Extension
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Buy Coin Detail View
@available(iOS 15.0, *)
struct BuyCoinDetailView: View {
    
    let coin: CoinModel
    let homeVM: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var quantityText: String = ""
    @State private var amountText: String = ""
    @State private var selectedInput: InputType = .quantity
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var isQuantityFocused: Bool
    @FocusState private var isAmountFocused: Bool
    
    enum InputType {
        case quantity, amount
    }
    
    private var currentPrice: Double {
        coin.currentPrice
    }
    
    private var totalCost: Double {
        if selectedInput == .quantity {
            return (Double(quantityText) ?? 0) * currentPrice
        } else {
            return Double(amountText) ?? 0
        }
    }
    
    private var quantityToBuy: Double {
        if selectedInput == .quantity {
            return Double(quantityText) ?? 0
        } else {
            return (Double(amountText) ?? 0) / currentPrice
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        CoinImageView(coin: coin)
                            .frame(width: 60, height: 60)
                        
                        VStack(spacing: 4) {
                            Text("Buy \(coin.name)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color.theme.accent)
                            
                            Text((coin.currentPrice.asCurrencyWith6Decimals()).replacingOccurrences(of: "$", with: "$"))
                                .font(.headline)
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                    .padding(.top)
                    
                    // Input Selection
                    Picker("Input Type", selection: $selectedInput) {
                        Text("Quantity").tag(InputType.quantity)
                        Text("Amount ($)").tag(InputType.amount)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Input Fields
                    VStack(spacing: 16) {
                        if selectedInput == .quantity {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Quantity (\(coin.symbol.uppercased()))")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.accent)
                                
                                TextField("0.00", text: $quantityText)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .focused($isQuantityFocused)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Total Cost (USD)")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.accent)
                                
                                Text("$\(totalCost.asNumberString())")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color.theme.green)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Amount to Spend (USD)")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.accent)
                                
                                TextField("0.00", text: $amountText)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .focused($isAmountFocused)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("You'll Get (\(coin.symbol.uppercased()))")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.accent)
                                
                                Text("\(quantityToBuy.asNumberString())")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color.theme.green)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Keyboard Dismiss Button
                    if isQuantityFocused || isAmountFocused {
                        HStack {
                            Spacer()
                            Button("Done") {
                                hideKeyboard()
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                        .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    // Buy Button
                    Button(action: {
                        buyCoins()
                    }) {
                        Text("Buy \(coin.symbol.uppercased())")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.theme.green, Color.green]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    .disabled(quantityToBuy <= 0)
                    .opacity(quantityToBuy <= 0 ? 0.6 : 1.0)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Buy Coin")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Purchase Complete"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func buyCoins() {
        guard quantityToBuy > 0 else { return }
        
        // Get current holdings if any
        let currentHoldings = homeVM.portfolioCoins.first(where: { $0.id == coin.id })?.currentHoldings ?? 0
        
        // Add to existing holdings
        let newAmount = currentHoldings + quantityToBuy
        
        homeVM.updatePortfolio(coin: coin, amount: newAmount)
        
        alertMessage = "Successfully purchased \(quantityToBuy.asNumberString()) \(coin.symbol.uppercased()) for $\(totalCost.asNumberString())"
        showingAlert = true
        
        // Clear inputs
        quantityText = ""
        amountText = ""
    }
}

// MARK: - COMPLETELY REWRITTEN SELL COIN DETAIL VIEW
@available(iOS 15.0, *)
struct SellCoinDetailView: View {
    
    let coin: CoinModel
    let homeVM: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // State variables
    @State private var quantityText: String = ""
    @State private var percentageToSell: Double = 0.0
    @State private var selectedInput: InputType = .quantity
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @FocusState private var isQuantityFocused: Bool
    
    enum InputType: CaseIterable {
        case quantity, percentage
        
        var displayName: String {
            switch self {
            case .quantity: return "Quantity"
            case .percentage: return "Percentage"
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var currentHoldings: Double {
        let holdings = homeVM.portfolioCoins.first(where: { $0.id == coin.id })?.currentHoldings ?? 0
        return holdings
    }
    
    private var currentPrice: Double {
        return coin.currentPrice
    }
    
    private var totalHoldingsValue: Double {
        return currentHoldings * currentPrice
    }
    
    // MAIN CALCULATION - Fixed logic
    private var quantityToSell: Double {
        switch selectedInput {
        case .quantity:
            let inputQuantity = Double(quantityText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
            // Ensure we don't sell more than we have
            return min(max(inputQuantity, 0.0), currentHoldings)
            
        case .percentage:
            let calculatedQuantity = currentHoldings * (percentageToSell / 100.0)
            return max(calculatedQuantity, 0.0)
        }
    }
    
    private var saleValue: Double {
        return quantityToSell * currentPrice
    }
    
    private var remainingQuantity: Double {
        return max(currentHoldings - quantityToSell, 0.0)
    }
    
    private var remainingValue: Double {
        return remainingQuantity * currentPrice
    }
    
    private var isValidSale: Bool {
        return quantityToSell > 0 && quantityToSell <= currentHoldings && currentHoldings > 0
    }
    
    // MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.theme.background,
                        Color.red.opacity(0.02)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Header Section
                        headerSection
                        
                        // MARK: - Holdings Info
                        holdingsInfoSection
                        
                        // MARK: - Input Type Picker
                        inputTypePickerSection
                        
                        // MARK: - Input Fields
                        inputFieldsSection
                        
                        // MARK: - Transaction Summary
                        transactionSummarySection
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                // MARK: - Bottom Section
                VStack {
                    Spacer()
                    
                    // Keyboard dismiss button
                    if isQuantityFocused {
                        keyboardDismissButton
                    }
                    
                    // Sell button
                    sellButtonSection
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
            .navigationTitle("Sell \(coin.symbol.uppercased())")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertTitle == "Sale Complete" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
        .onAppear {
            // Initialize with current holdings info
            if currentHoldings <= 0 {
                alertTitle = "No Holdings"
                alertMessage = "You don't own any \(coin.symbol.uppercased()) to sell."
                showingAlert = true
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Coin image
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.red.opacity(0.1), Color.orange.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                CoinImageView(coin: coin)
                    .frame(width: 60, height: 60)
            }
            .shadow(color: Color.red.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Coin info
            VStack(spacing: 8) {
                Text(coin.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.theme.accent)
                
                Text((coin.currentPrice.asCurrencyWith6Decimals()).replacingOccurrences(of: "$", with: "$"))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var holdingsInfoSection: some View {
        VStack(spacing: 12) {
            Text("Your Holdings")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.theme.accent)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quantity")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("\(currentHoldings.asNumberString()) \(coin.symbol.uppercased())")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total Value")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("$\(totalHoldingsValue.asNumberString())")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.theme.green)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var inputTypePickerSection: some View {
        Picker("Input Type", selection: $selectedInput) {
            ForEach(InputType.allCases, id: \.self) { type in
                Text(type.displayName).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.vertical, 8)
    }
    
    private var inputFieldsSection: some View {
        VStack(spacing: 20) {
            if selectedInput == .quantity {
                quantityInputSection
            } else {
                percentageInputSection
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
    }
    
    private var quantityInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quantity to Sell")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.theme.accent)
            
            HStack {
                if #available(iOS 15.0, *) {
                    TextField("0.00", text: $quantityText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isQuantityFocused)
                } else {
                    // Fallback on earlier versions
                }
                
                Text(coin.symbol.uppercased())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Validation message
            if !quantityText.isEmpty {
                let inputValue = Double(quantityText) ?? 0
                if inputValue > currentHoldings {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Cannot sell more than you own (\(currentHoldings.asNumberString()))")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                    }
                } else if inputValue > 0 {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Valid quantity")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Quick amount buttons
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Select")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                HStack(spacing: 8) {
                    ForEach([0.25, 0.5, 0.75, 1.0], id: \.self) { fraction in
                        Button(action: {
                            let amount = currentHoldings * fraction
                            quantityText = String(format: "%.6f", amount)
                        }) {
                            Text("\(Int(fraction * 100))%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
    
    private var percentageInputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Percentage to Sell")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.theme.accent)
            
            VStack(spacing: 12) {
                // Slider
                Slider(value: $percentageToSell, in: 0...100, step: 1)
                    .accentColor(.red)
                
                // Percentage display
                HStack {
                    Text("0%")
                        .font(.system(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Spacer()
                    
                    Text("\(Int(percentageToSell))%")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Text("100%")
                        .font(.system(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                // Quick percentage buttons
                HStack(spacing: 12) {
                    ForEach([25, 50, 75, 100], id: \.self) { percentage in
                        Button(action: {
                            percentageToSell = Double(percentage)
                        }) {
                            Text("\(percentage)%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(percentageToSell == Double(percentage) ? .white : .red)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    percentageToSell == Double(percentage) ?
                                    Color.red : Color.red.opacity(0.1)
                                )
                                .cornerRadius(16)
                        }
                    }
                }
            }
        }
    }
    
    private var transactionSummarySection: some View {
        VStack(spacing: 16) {
            Text("Transaction Summary")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                summaryRow(
                    title: "Selling",
                    value: "\(quantityToSell.asNumberString()) \(coin.symbol.uppercased())",
                    valueColor: quantityToSell > 0 ? Color.red : Color.theme.secondaryText
                )
                
                summaryRow(
                    title: "You'll Receive",
                    value: "$\(saleValue.asNumberString())",
                    valueColor: saleValue > 0 ? Color.theme.green : Color.theme.secondaryText
                )
                
                Divider()
                
                summaryRow(
                    title: "Remaining Holdings",
                    value: "\(remainingQuantity.asNumberString()) \(coin.symbol.uppercased())",
                    valueColor: Color.theme.secondaryText
                )
                
                summaryRow(
                    title: "Remaining Value",
                    value: "$\(remainingValue.asNumberString())",
                    valueColor: Color.theme.secondaryText
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red.opacity(0.2), Color.orange.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private func summaryRow(title: String, value: String, valueColor: Color) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(valueColor)
        }
    }
    
    private var keyboardDismissButton: some View {
        HStack {
            Spacer()
            Button(action: {
                hideKeyboard()
            }) {
                Text("Done")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: isQuantityFocused)
    }
    
    private var sellButtonSection: some View {
        Button(action: {
            executeSale()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 20, weight: .bold))
                
                Text("Sell \(coin.symbol.uppercased())")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isValidSale ? [Color.red, Color.red.opacity(0.8)] : [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(28)
            .shadow(color: isValidSale ? Color.red.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!isValidSale)
        .scaleEffect(isValidSale ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.2), value: isValidSale)
    }
    
    // MARK: - Functions
    
    private func executeSale() {
        // Final validation
        guard isValidSale else {
            alertTitle = "Invalid Sale"
            alertMessage = "Please check your input and try again."
            showingAlert = true
            return
        }
        
        guard currentHoldings > 0 else {
            alertTitle = "No Holdings"
            alertMessage = "You don't have any \(coin.symbol.uppercased()) to sell."
            showingAlert = true
            return
        }
        
        guard quantityToSell > 0 else {
            alertTitle = "Invalid Quantity"
            alertMessage = "Please enter a valid quantity to sell."
            showingAlert = true
            return
        }
        
        guard quantityToSell <= currentHoldings else {
            alertTitle = "Insufficient Holdings"
            alertMessage = "You're trying to sell \(quantityToSell.asNumberString()) \(coin.symbol.uppercased()) but you only have \(currentHoldings.asNumberString()) \(coin.symbol.uppercased())."
            showingAlert = true
            return
        }
        
        // Execute the sale
        let newHoldings = currentHoldings - quantityToSell
        
        // Update portfolio through HomeViewModel
        homeVM.updatePortfolio(coin: coin, amount: newHoldings)
        
        // Show success message
        alertTitle = "Sale Complete"
        alertMessage = "Successfully sold \(quantityToSell.asNumberString()) \(coin.symbol.uppercased()) for $\(saleValue.asNumberString())"
        showingAlert = true
        
        // Reset form
        quantityText = ""
        percentageToSell = 0.0
        hideKeyboard()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
            .environmentObject(dev.homeVM)
    }
}
