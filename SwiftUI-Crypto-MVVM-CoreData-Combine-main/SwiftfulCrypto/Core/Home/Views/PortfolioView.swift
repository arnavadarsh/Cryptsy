//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//
import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced background
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
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Enhanced Search Bar
                        SearchBarView(searchText: $vm.searchText)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        // Enhanced Coin Logo List
                        coinLogoList
                            .padding(.vertical, 8)
                        
                        if selectedCoin != nil {
                            enhancedPortfolioInputSection
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 0)
                    }
                }
            }
            .navigationTitle("📊 Edit Portfolio")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 16))
                            Text("Home")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.1))
                        )
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: { showSettingsView = true }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                )
                        }
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                                .font(.system(size: 16, weight: .bold))
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
                    }
                }
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}

extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    enhancedCoinLogoView(coin: coin)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                }
            }
            .frame(height: 120)
            .padding(.leading, 20)
        }
    }
    
    private func enhancedCoinLogoView(coin: CoinModel) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(
                                selectedCoin?.id == coin.id ?
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.2)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: selectedCoin?.id == coin.id ? 3 : 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                CoinImageView(coin: coin)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                if selectedCoin?.id == coin.id {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                        )
                        .offset(x: 20, y: -20)
                }
            }
            
            Text(coin.symbol.uppercased())
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(selectedCoin?.id == coin.id ? Color.blue : Color.theme.secondaryText)
        }
        .frame(width: 80)
        .scaleEffect(selectedCoin?.id == coin.id ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCoin?.id == coin.id)
    }
    
    private var enhancedPortfolioInputSection: some View {
        VStack(spacing: 24) {
            // Coin Info Header
            HStack(spacing: 16) {
                CoinImageView(coin: selectedCoin!)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedCoin?.symbol.uppercased() ?? "")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text(selectedCoin?.name ?? "")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            
            // Enhanced Input Section
            VStack(spacing: 20) {
                // Current Price
                enhancedInfoRow(
                    icon: "💰",
                    title: "Current Price",
                    value: selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? ""
                )
                
                Divider()
                
                // Amount Input
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("📊")
                            .font(.system(size: 16))
                        Text("Amount Holding")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.theme.accent)
                    }
                    
                    HStack {
                        TextField("Ex: 1.4", text: $quantityText)
                            .font(.system(size: 18, weight: .semibold))
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        
                        Text(selectedCoin?.symbol.uppercased() ?? "")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.theme.secondaryText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.1))
                            )
                    }
                }
                
                Divider()
                
                // Current Value
                enhancedInfoRow(
                    icon: "💎",
                    title: "Current Value",
                    value: getCurrentValue().asCurrencyWith2Decimals()
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
            )
            
            // Enhanced Action Buttons
            HStack(spacing: 16) {
                Button(action: saveButtonPressed) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                        Text("Save Changes")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .opacity(
                        (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ?
                        1.0 : 0.6
                    )
                    .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedCoin == nil)
                
                if selectedCoin?.currentHoldings != nil {
                    Button(action: removeButtonPressed) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 18))
                            Text("Remove")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red, Color.orange]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
        }
    }
    
    private func enhancedInfoRow(icon: String, title: String, value: String) -> some View {
        HStack {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.theme.accent)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.spring()) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring()) {
                showCheckmark = false
            }
        }
    }
    
    private func removeButtonPressed() {
        guard let coin = selectedCoin else { return }
        
        vm.updatePortfolio(coin: coin, amount: 0)
        
        withAnimation(.spring()) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring()) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
        quantityText = ""
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
