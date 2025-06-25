//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var showProfileView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var selectedTab: TabSelection = .home
    @State private var showSortOptions: Bool = false
    
    @AppStorage("firstName") private var firstName: String = "User"
    @AppStorage("userName") private var userName: String = "Your Name"
    @AppStorage("profileImageData") private var profileImageData: Data?
    
    enum TabSelection {
        case home, portfolio, settings
    }
    
    var body: some View {
        GeometryReader { geometry in
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
                
                VStack(spacing: 0) {
                    // Enhanced Header
                    modernHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    
                    // Main Content
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 24) {
                            // Hero Stats Section - NOW WITH REAL-TIME DATA
                            heroStatsSection
                            
                            // Search & Sort Section
                            modernSearchSection
                                .padding(.horizontal, 20)
                            
                            // Column Headers
                            modernColumnHeaders
                                .padding(.horizontal, 20)
                            
                            // Coins List with enhanced cards
                            coinsListSection
                                .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    
                    // Modern Bottom Tab Bar
                    modernBottomBar
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                }
                
                // Enhanced Sort Options
                if showSortOptions {
                    modernSortOverlay
                }
            }
        }
        .sheet(isPresented: $showPortfolioView) {
            PortfolioView()
                .environmentObject(vm)
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView()
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
        .onChange(of: selectedTab) { newTab in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                switch newTab {
                case .home:
                    showPortfolio = false
                    vm.showPortfolio = false
                case .portfolio:
                    showPortfolio = true
                    vm.showPortfolio = true
                case .settings:
                    showSettingsView = true
                }
            }
        }
        .onChange(of: showPortfolio) { value in
            vm.showPortfolio = value
        }
    }
}

extension HomeView {
    
    private var modernHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(timeBasedGreeting)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(displayFirstName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                    .shadow(color: Color.theme.accent.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Notification Button
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 48, height: 48)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color.theme.accent)
                        
                        // Notification dot
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 14, y: -14)
                    }
                }
                
                // Profile Button
                Button(action: { showProfileView = true }) {
                    if let data = profileImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    } else {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 48, height: 48)
                                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
    
    // UPDATED: Real-time Stats Section
    private var heroStatsSection: some View {
        VStack(spacing: 16) {
            // Title with enhanced styling
            HStack {
                Text(showPortfolio ? "📈 Portfolio Overview" : "🌍 Live Market")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                
                Spacer()
                
                // Market Status Indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .shadow(color: Color.green, radius: 2)
                    
                    Text("Live")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.1))
                )
            }
            .padding(.horizontal, 20)
            
            // REAL-TIME STATS VIEW - Connected to actual data
            realTimeStatsView
                .padding(.horizontal, 20)
        }
    }
    
    // NEW: Real-time Stats View with actual calculations
    private var realTimeStatsView: some View {
        HStack(spacing: 16) {
            if showPortfolio {
                // Portfolio Stats (Left Card)
                portfolioStatsCard
                
                // Portfolio Performance (Right Card)
                portfolioPerformanceCard
            } else {
                // Global Market Stats (Left Card)
                globalMarketStatsCard
                
                // Market Performance (Right Card)
                marketPerformanceCard
            }
        }
    }
    
    // PORTFOLIO STATS - Real calculations
    private var portfolioStatsCard: some View {
        VStack(spacing: 12) {
            // Portfolio Value
            VStack(spacing: 4) {
                Text("Portfolio Value")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(portfolioValue.asCurrencyWith2Decimals())
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.theme.accent)
            }
            
            Divider()
                .opacity(0.5)
            
            // Portfolio Change
            VStack(spacing: 4) {
                Text("24h Change")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                HStack(spacing: 4) {
                    Image(systemName: portfolioChange24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10, weight: .bold))
                    
                    Text(portfolioChange24h.asCurrencyWith2Decimals())
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(portfolioChange24h >= 0 ? Color.theme.green : Color.theme.red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
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
    
    private var portfolioPerformanceCard: some View {
        VStack(spacing: 12) {
            // Number of Holdings
            VStack(spacing: 4) {
                Text("Holdings")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text("\(vm.portfolioCoins.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.theme.accent)
            }
            
            Divider()
                .opacity(0.5)
            
            // Portfolio Percentage Change
            VStack(spacing: 4) {
                Text("24h %")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                HStack(spacing: 4) {
                    Image(systemName: portfolioChangePercentage24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10, weight: .bold))
                    
                    Text(portfolioChangePercentage24h.asPercentString())
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(portfolioChangePercentage24h >= 0 ? Color.theme.green : Color.theme.red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.green.opacity(0.02)
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
                                    Color.green.opacity(0.1),
                                    Color.blue.opacity(0.1)
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
    
    // GLOBAL MARKET STATS - Real calculations
    private var globalMarketStatsCard: some View {
        VStack(spacing: 12) {
            // Market Cap
            VStack(spacing: 4) {
                Text("Market Cap")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(globalMarketCap.formattedWithAbbreviations())
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.theme.accent)
            }
            
            Divider()
                .opacity(0.5)
            
            // Volume
            VStack(spacing: 4) {
                Text("24h Volume")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(globalVolume.formattedWithAbbreviations())
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
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
    
    private var marketPerformanceCard: some View {
        VStack(spacing: 12) {
            // BTC Dominance
            VStack(spacing: 4) {
                Text("BTC Dominance")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(btcDominance.asPercentString())
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.theme.accent)
            }
            
            Divider()
                .opacity(0.5)
            
            // Active Cryptocurrencies
            VStack(spacing: 4) {
                Text("Active Coins")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text("\(vm.allCoins.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.orange.opacity(0.02)
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
                                    Color.orange.opacity(0.1),
                                    Color.yellow.opacity(0.1)
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
    
    // MARK: - Computed Properties for Real-time Data
    
    // Portfolio Calculations
    private var portfolioValue: Double {
        return vm.portfolioCoins.reduce(0) { (result, coin) in
            return result + (coin.currentHoldings ?? 0) * coin.currentPrice
        }
    }
    
    private var portfolioChange24h: Double {
        return vm.portfolioCoins.reduce(0) { (result, coin) in
            let currentValue = (coin.currentHoldings ?? 0) * coin.currentPrice
            let previousValue = currentValue / (1 + (coin.priceChangePercentage24H ?? 0) / 100)
            return result + (currentValue - previousValue)
        }
    }
    
    private var portfolioChangePercentage24h: Double {
        let previousValue = portfolioValue - portfolioChange24h
        return previousValue > 0 ? (portfolioChange24h / previousValue) * 100 : 0
    }
    
    // Global Market Calculations
    private var globalMarketCap: Double {
        return vm.allCoins.reduce(0) { (result, coin) in
            return result + (coin.marketCap ?? 0)
        }
    }
    
    private var globalVolume: Double {
        return vm.allCoins.reduce(0) { (result, coin) in
            return result + (coin.totalVolume ?? 0)
        }
    }
    
    private var btcDominance: Double {
        guard let bitcoin = vm.allCoins.first(where: { $0.symbol.lowercased() == "btc" }),
              let btcMarketCap = bitcoin.marketCap,
              globalMarketCap > 0 else {
            return 0
        }
        return (btcMarketCap / globalMarketCap) * 100
    }
    
    private var modernSearchSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                // Enhanced Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.theme.secondaryText)
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("🔍 Search coins, symbols...", text: $vm.searchText)
                        .foregroundColor(Color.theme.accent)
                        .font(.system(size: 16, weight: .medium))
                    
                    if !vm.searchText.isEmpty {
                        Button(action: {
                            vm.searchText = ""
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.theme.secondaryText)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                
                // Enhanced Sort Button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showSortOptions.toggle()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 14, weight: .bold))
                        Text("Sort")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
        }
    }
    
    private var modernColumnHeaders: some View {
        HStack {
            HStack(spacing: 4) {
                Text("💰 Coin")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.accent)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.theme.accent)
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.3)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("📊 Holdings")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.3)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("💵 Price")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.accent)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.theme.accent)
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.3)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: 100, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private var coinsListSection: some View {
        LazyVStack(spacing: 12) {
            if !showPortfolio {
                ForEach(vm.allCoins) { coin in
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .onTapGesture {
                            segue(coin: coin)
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
            } else {
                if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                    portfolioEmptyState
                } else {
                    ForEach(vm.portfolioCoins) { coin in
                        CoinRowView(coin: coin, showHoldingsColumn: true)
                            .onTapGesture {
                                segue(coin: coin)
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                }
            }
        }
    }
    
    private var portfolioEmptyState: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 40)
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Text("📊")
                    .font(.system(size: 60))
            }
            
            VStack(spacing: 8) {
                Text("Your Portfolio Awaits")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                
                Text("Start building your crypto portfolio by adding your first investment")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showPortfolioView = true }) {
                HStack(spacing: 8) {
                    Text("➕")
                        .font(.system(size: 16))
                    Text("Add Your First Coin")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
                .frame(height: 60)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var modernBottomBar: some View {
        HStack {
            ModernTabButton(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == .home
            ) {
                selectedTab = .home
            }
            
            Spacer()
            
            ModernTabButton(
                icon: "chart.pie.fill",
                title: "Portfolio",
                isSelected: selectedTab == .portfolio
            ) {
                selectedTab = .portfolio
            }
            
            Spacer()
            
            ModernTabButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == .settings
            ) {
                selectedTab = .settings
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }
    
    private var modernSortOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        showSortOptions = false
                    }
                }
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("🔄 Sort Options")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color.theme.accent)
                        
                        Spacer()
                        
                        Button("Done") {
                            withAnimation(.spring()) {
                                showSortOptions = false
                            }
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    
                    Divider()
                        .padding(.horizontal, 24)
                    
                    // Sort Options
                    ScrollView {
                        LazyVStack(spacing: 4) {
                            ForEach(availableSortOptions, id: \.self) { option in
                                modernSortRow(option: option)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .frame(maxHeight: 300)
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: -10)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private func modernSortRow(option: HomeViewModel.SortOption) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                vm.sortOption = option
                showSortOptions = false
            }
        }) {
            HStack(spacing: 16) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(vm.sortOption == option ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: option.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(vm.sortOption == option ? .blue : Color.theme.secondaryText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text(option.description)
                        .font(.system(size: 13))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: vm.sortOption == option ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(vm.sortOption == option ? .blue : Color.theme.secondaryText)
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(vm.sortOption == option ? Color.blue.opacity(0.05) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var availableSortOptions: [HomeViewModel.SortOption] {
        if showPortfolio {
            return [.holdings, .holdingsReversed, .rank, .rankReversed, .marketCap, .marketCapReversed, .price, .priceReversed, .priceChange24h, .priceChange24hReversed]
        } else {
            return [.rank, .rankReversed, .marketCap, .marketCapReversed, .price, .priceReversed, .priceChange24h, .priceChange24hReversed]
        }
    }
    
    private var displayFirstName: String {
        if !firstName.isEmpty && firstName != "User" {
            return firstName
        } else {
            let components = userName.components(separatedBy: " ")
            return components.first ?? "User"
        }
    }
    
    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "🌅 Good Morning"
        case 12..<17:
            return "☀️ Good Afternoon"
        case 17..<22:
            return "🌆 Good Evening"
        default:
            return "🌙 Good Night"
        }
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

// MARK: - Extensions for Number Formatting


struct ModernTabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSelected ? .white : Color.theme.secondaryText)
                }
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.accent : Color.theme.secondaryText)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

