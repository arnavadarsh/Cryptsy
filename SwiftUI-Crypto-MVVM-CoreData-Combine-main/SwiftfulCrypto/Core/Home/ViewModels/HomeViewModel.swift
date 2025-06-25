//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    @Published var showPortfolio: Bool = false {
        didSet {
            updateStatistics()
        }
    }
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    // ADDED: Auto-refresh timer
    private var refreshTimer: Timer?
    
    enum SortOption: CaseIterable {
        case rank, rankReversed, holdings, holdingsReversed, marketCap, marketCapReversed, price, priceReversed, priceChange24h, priceChange24hReversed, volume24h, volume24hReversed
        
        var title: String {
            switch self {
            case .rank, .rankReversed: return "Rank"
            case .holdings, .holdingsReversed: return "Holdings"
            case .marketCap, .marketCapReversed: return "Market Cap"
            case .price, .priceReversed: return "Price"
            case .priceChange24h, .priceChange24hReversed: return "24h Change"
            case .volume24h, .volume24hReversed: return "24h Volume"
            }
        }
        
        var description: String {
            switch self {
            case .rank: return "Sort by market cap rank (lowest first)"
            case .rankReversed: return "Sort by market cap rank (highest first)"
            case .holdings: return "Sort by holdings value (highest first)"
            case .holdingsReversed: return "Sort by holdings value (lowest first)"
            case .marketCap: return "Sort by market cap (highest first)"
            case .marketCapReversed: return "Sort by market cap (lowest first)"
            case .price: return "Sort by price (highest first)"
            case .priceReversed: return "Sort by price (lowest first)"
            case .priceChange24h: return "Sort by 24h change (highest first)"
            case .priceChange24hReversed: return "Sort by 24h change (lowest first)"
            case .volume24h: return "Sort by 24h volume (highest first)"
            case .volume24hReversed: return "Sort by 24h volume (lowest first)"
            }
        }
        
        var icon: String {
            switch self {
            case .rank, .rankReversed: return "number"
            case .holdings, .holdingsReversed: return "briefcase"
            case .marketCap, .marketCapReversed: return "chart.pie"
            case .price, .priceReversed: return "dollarsign.circle"
            case .priceChange24h, .priceChange24hReversed: return "chart.line.uptrend.xyaxis"
            case .volume24h, .volume24hReversed: return "chart.bar"
            }
        }
    }
    
    init() {
        addSubscribers()
        startAutoRefresh() // ADDED: Start auto-refresh
    }
    
    // ADDED: Clean up timer when object is deallocated
    deinit {
        refreshTimer?.invalidate()
    }
    
    // ADDED: Auto-refresh functionality
    private func startAutoRefresh() {
        // Refresh every 60 seconds (1 minute)
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadData()
            }
        }
    }
    
    // ADDED: Stop auto-refresh (useful for when app goes to background)
    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    // ADDED: Resume auto-refresh (useful for when app comes to foreground)
    func resumeAutoRefresh() {
        if refreshTimer == nil {
            startAutoRefresh()
        }
    }
    
    func addSubscribers() {
        
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map { [weak self] (marketDataModel, portfolioCoins) -> [StatisticModel] in
                guard let self = self else { return [] }
                return self.mapGlobalMarketData(marketDataModel: marketDataModel, portfolioCoins: portfolioCoins)
            }
            .sink { [weak self] (returnedStats: [StatisticModel]) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    // ENHANCED: Improved reload function with better feedback
    func reloadData() {
        print("🔄 Refreshing all cryptocurrency data...")
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
        
        // ADDED: Completion feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
            print("✅ Data refresh completed!")
        }
    }
    
    private func updateStatistics() {
        if let marketData = marketDataService.marketData {
            statistics = mapGlobalMarketData(marketDataModel: marketData, portfolioCoins: portfolioCoins)
        }
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .marketCap:
            coins.sort(by: { $0.marketCap ?? 0 > $1.marketCap ?? 0 })
        case .marketCapReversed:
            coins.sort(by: { $0.marketCap ?? 0 < $1.marketCap ?? 0 })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .priceChange24h:
            coins.sort(by: { $0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0 })
        case .priceChange24hReversed:
            coins.sort(by: { $0.priceChangePercentage24H ?? 0 < $1.priceChangePercentage24H ?? 0 })
        case .volume24h:
            coins.sort(by: { $0.totalVolume ?? 0 > $1.totalVolume ?? 0 })
        case .volume24hReversed:
            coins.sort(by: { $0.totalVolume ?? 0 < $1.totalVolume ?? 0 })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // will only sort by holdings or reversedholdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        // Calculate portfolio value for both views
        let portfolioValue = portfolioCoins
            .map({ (coin) -> Double in
                return coin.currentHoldingsValue
            })
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = previousValue > 0 ? ((portfolioValue - previousValue) / previousValue) : 0
        
        if showPortfolio {
            // PORTFOLIO STATISTICS (6 stats)
            let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
            
            let volume = StatisticModel(title: "24h Volume", value: data.volume)
            
            let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
            
            let portfolio = StatisticModel(
                title: "Portfolio Value",
                value: portfolioValue.asCurrencyWith2Decimals(),
                percentageChange: percentageChange)
            
            let portfolioChange = StatisticModel(
                title: "24h Change",
                value: (portfolioValue - previousValue).asCurrencyWith2Decimals(),
                percentageChange: percentageChange)
            
            let holdingsCount = StatisticModel(title: "Holdings", value: "\(portfolioCoins.count)")
            
            stats.append(contentsOf: [
                marketCap,
                volume,
                btcDominance,
                portfolio,
                portfolioChange,
                holdingsCount
            ])
        } else {
            // LIVE MARKET STATISTICS (4 stats) - Now includes Portfolio Value instead of Active Cryptos
            let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
            
            let volume = StatisticModel(title: "24h Volume", value: data.volume)
            
            let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
            
            let portfolioStat = StatisticModel(
                title: "Portfolio Value",
                value: portfolioValue > 0 ? portfolioValue.asCurrencyWith2Decimals() : "$0.00",
                percentageChange: portfolioValue > 0 ? percentageChange : nil)
            
            stats.append(contentsOf: [
                marketCap,
                volume,
                btcDominance,
                portfolioStat
            ])
        }
        
        return stats
    }
}
