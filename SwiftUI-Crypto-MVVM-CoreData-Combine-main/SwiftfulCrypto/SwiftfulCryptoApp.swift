////
////  SwiftfulCryptoApp.swift
////  SwiftfulCrypto
////
//
//import SwiftUI
//
//@main//app starts here
//struct SwiftfulCryptoApp: App {
//    
//    @StateObject private var vm = HomeViewModel()
//    @State private var showLaunchView: Bool = true
//    @State private var isLocked: Bool = true
//    
//    // App settings
//    @AppStorage("faceIDEnabled") private var faceIDEnabled: Bool = true
//    @AppStorage("userPasscode") private var userPasscode: String = "1234"
//    
//    init() {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
//        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
//        UITableView.appearance().backgroundColor = UIColor.clear
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            ZStack {
//                // Main App (only shows when unlocked)
//                if !isLocked {
//                    NavigationView {
//                        HomeView()
//                            .navigationBarHidden(true)
//                    }
//                    .navigationViewStyle(StackNavigationViewStyle())
//                    .environmentObject(vm)
//                    .transition(.opacity)
//                }
//                
//                // Lock Screen (shows after launch, before app)
//                if !showLaunchView && isLocked {
//                    LockView(
//                        isLocked: $isLocked,
//                        faceIDEnabled: faceIDEnabled,
//                        userPasscode: userPasscode
//                    )
//                    .transition(.opacity)
//                    .zIndex(1.0)
//                }
//                
//                // Launch Screen (shows first)
//                if showLaunchView {
//                    LaunchView(showLaunchView: $showLaunchView)
//                        .transition(.move(edge: .leading))
//                        .zIndex(2.0)
//                }
//                // .zIndex controls stacking (who appears on top)
//                //HomeView → No .zIndex (default = 0.0)
//                //LockView → .zIndex(1.0)
//               // LaunchView → .zIndex(2.0)
//
//
//            }
//            .animation(.easeInOut(duration: 0.5), value: showLaunchView)//transition between screen
//            .animation(.easeInOut(duration: 0.5), value: isLocked)//transition between screenokn
//        }
//    }
//}
//
// 
//
//
//  PreviewProvider.swift
//  Cryptsy
//
//  Created by Arnav Adarsh on 5/05/25
//
import SwiftUI

@main // app starts here
struct SwiftfulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    @State private var isLocked: Bool = true
    
    // App settings
    @AppStorage("userPasscode") private var userPasscode: String = "1234"
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main App (only shows when unlocked)
                if !isLocked {
                    NavigationView {
                        HomeView()
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .environmentObject(vm)
                    .transition(.opacity)
                }
                
                // Lock Screen (shows after launch, before app)
                if !showLaunchView && isLocked {
                    LockView(
                        isLocked: $isLocked,
                        userPasscode: userPasscode
                    )
                    .transition(.opacity)
                    .zIndex(1.0)
                }
                
                // Launch Screen (shows first)
                if showLaunchView {
                    LaunchView(showLaunchView: $showLaunchView)
                        .transition(.move(edge: .leading))
                        .zIndex(2.0)
                }
                // .zIndex controls stacking (who appears on top)
                // HomeView → No .zIndex (default = 0.0)
                // LockView → .zIndex(1.0)
                // LaunchView → .zIndex(2.0)
            }
            .animation(.easeInOut(duration: 0.5), value: showLaunchView) // transition between screens
            .animation(.easeInOut(duration: 0.5), value: isLocked) // transition between screens
        }
    }
}
