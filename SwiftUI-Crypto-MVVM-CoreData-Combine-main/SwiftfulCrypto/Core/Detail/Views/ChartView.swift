//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//
import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    private let priceChange: Double
    private let priceChangePercentage: Double
    
    @State private var percentage: CGFloat = 0
    @State private var selectedPoint: CGPoint? = nil
    @State private var selectedValue: Double? = nil
    @State private var showGradient: Bool = true
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let firstPrice = data.first ?? 0
        let lastPrice = data.last ?? 0
        priceChange = lastPrice - firstPrice
        priceChangePercentage = firstPrice != 0 ? (priceChange / firstPrice) * 100 : 0
        
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Chart Performance Stats - Centered
            chartStatsRow
                .padding(.horizontal, 20)
            
            // Enhanced Chart View - Centered
            enhancedChartView
                .frame(height: 220)
                .padding(.horizontal, 16)
            
            // Enhanced Date Labels - Centered
            chartBottomSection
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

extension ChartView {
    
    private var chartStatsRow: some View {
        HStack(spacing: 16) {
            // Price Change - Centered
            VStack(spacing: 8) {
                Text("Price Change")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity)
                
                Text(priceChange.asCurrencyWith6Decimals())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(lineColor)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(lineColor.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineColor.opacity(0.2), lineWidth: 1)
                    )
            )
            
            // Percentage Change - Centered
            VStack(spacing: 8) {
                Text("Percentage")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity)
                
                HStack(spacing: 4) {
                    Image(systemName: priceChangePercentage >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 12, weight: .bold))
                    
                    Text(priceChangePercentage.asPercentString())
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(lineColor)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(lineColor.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineColor.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
    
    private var enhancedChartView: some View {
        ZStack {
            // Background Grid
            chartBackground
            
            // Y-Axis Labels
            HStack {
                chartYAxis
                    .padding(.leading, 8)
                Spacer()
            }
            
            // Main Chart
            GeometryReader { geometry in
                ZStack {
                    // Gradient Fill Area
                    if showGradient {
                        gradientPath(in: geometry)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        lineColor.opacity(0.3),
                                        lineColor.opacity(0.1),
                                        lineColor.opacity(0.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Main Chart Line
                    chartPath(in: geometry)
                        .trim(from: 0, to: percentage)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    lineColor,
                                    lineColor.opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                        )
                        .shadow(color: lineColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    // Interactive Overlay
                    interactiveOverlay(in: geometry)
                }
            }
            .padding(.horizontal, 40)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.02))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
    
    private var chartBackground: some View {
        VStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { index in
                if index > 0 {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 0.5)
                }
                if index < 4 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 40)
    }
    
    private var chartYAxis: some View {
        VStack(spacing: 0) {
            Text(maxY.formattedWithAbbreviations())
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
            
            Spacer()
            
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
            
            Spacer()
            
            Text(minY.formattedWithAbbreviations())
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(width: 35)
    }
    
    private var chartBottomSection: some View {
        VStack(spacing: 16) {
            // Live indicator - Centered
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .shadow(color: Color.green, radius: 2)
                
                Text("Live Data • 7-Day Performance")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.green.opacity(0.1))
            )
            .frame(maxWidth: .infinity)
            
            // Date Labels - Centered
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("From")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text(startingDate.asShortDateString())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1, height: 30)
                
                VStack(spacing: 4) {
                    Text("To")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text(endingDate.asShortDateString())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
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
    }
    
    // MARK: - Helper Methods
    
    private func chartPath(in geometry: GeometryProxy) -> Path {
        Path { path in
            for index in data.indices {
                let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                let yAxis = maxY - minY
                let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                
                if index == 0 {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                }
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
            }
        }
    }
    
    private func gradientPath(in geometry: GeometryProxy) -> Path {
        Path { path in
            guard !data.isEmpty else { return }
            
            // Start from bottom left
            path.move(to: CGPoint(x: 0, y: geometry.size.height))
            
            // Draw the price line
            for index in data.indices {
                let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                let yAxis = maxY - minY
                let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                
                if index == 0 {
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                } else {
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            
            // Close the path at bottom right
            path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
            path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
        }
    }
    
    private func interactiveOverlay(in geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let x = value.location.x
                        let index = min(max(0, Int(x / geometry.size.width * CGFloat(data.count))), data.count - 1)
                        
                        if index < data.count {
                            selectedValue = data[index]
                            selectedPoint = CGPoint(
                                x: x,
                                y: (1 - CGFloat((data[index] - minY) / (maxY - minY))) * geometry.size.height
                            )
                        }
                    }
                    .onEnded { _ in
                        selectedPoint = nil
                        selectedValue = nil
                    }
            )
            .overlay(
                Group {
                    if let point = selectedPoint, let value = selectedValue {
                        VStack {
                            // Price tooltip
                            Text(value.asCurrencyWith6Decimals())
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.8))
                                )
                                .offset(y: -30)
                            
                            // Dot indicator
                            Circle()
                                .fill(Color.white)
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(lineColor, lineWidth: 3)
                                )
                                .shadow(color: lineColor.opacity(0.5), radius: 4)
                        }
                        .position(point)
                    }
                }
            )
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
            .padding()
            .background(Color.theme.background)
    }
}
