//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Logo in center
                Image("logo-transparent")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                // Loading text at bottom
                VStack(spacing: 16) {
                    if showLoadingText {
                        HStack(spacing: 0) {
                            ForEach(loadingText.indices, id: \.self) { index in
                                Text(loadingText[index])
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .offset(y: counter == index ? -5 : 0)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: counter)
                            }
                        }
                        .transition(AnyTransition.scale.animation(.easeIn))
                    }
                    
                    // Loading dots animation
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                                .scaleEffect(counter % 3 == index ? 1.5 : 1.0)
                                .opacity(counter % 3 == index ? 1.0 : 0.6)
                                .animation(
                                    .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                    value: counter
                                )
                        }
                    }
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
