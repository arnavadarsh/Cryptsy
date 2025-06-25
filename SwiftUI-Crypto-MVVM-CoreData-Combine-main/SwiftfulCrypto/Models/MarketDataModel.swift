
//
//  PreviewProvider.swift
//  Cryptsy
//
//  Created by Arnav Adarsh on 5/05/25
//
import Foundation

// MARK: - GlobalData
struct GlobalData: Codable {
    let data: MarketDataModel?
}

// MARK: - MarketDataModel
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    let activeCryptocurrencies, markets: Int
    let ongoingIcos, endedIcos, upcomingIcos: Int?
    let updatedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
        case activeCryptocurrencies = "active_cryptocurrencies"
        case markets
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case upcomingIcos = "upcoming_icos"
        case updatedAt = "updated_at"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
