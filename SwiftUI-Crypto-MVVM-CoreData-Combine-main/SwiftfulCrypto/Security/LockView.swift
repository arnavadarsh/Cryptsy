//import SwiftUI
//import LocalAuthentication
//
//struct LockView: View {
//    @Binding var isLocked: Bool
//    
//    let faceIDEnabled: Bool
//    let userPasscode: String
//    
//    @State private var showPasscodeSheet = false
//    @State private var enteredPasscode = ""
//    
//    var body: some View {
//        ZStack {
//            // Match app's background theme
//            Color.theme.background
//                .ignoresSafeArea()
//            
//            VStack(spacing: 50) {
//                Spacer()
//                
//                // App Logo Section
//                VStack(spacing: 30) {
//                    // Logo with subtle glow
//                    ZStack {
//                        Circle()
//                            .fill(
//                                RadialGradient(
//                                    gradient: Gradient(colors: [
//                                        Color.theme.accent.opacity(0.3),
//                                        Color.clear
//                                    ]),
//                                    center: .center,
//                                    startRadius: 0,
//                                    endRadius: 80
//                                )
//                            )
//                            .frame(width: 160, height: 160)
//                        
//                        Circle()
//                            .fill(Color.white.opacity(0.95))
//                            .frame(width: 120, height: 120)
//                            .shadow(color: Color.theme.accent.opacity(0.3), radius: 20, x: 0, y: 10)
//                        
//                        Image("logo-transparent")
//                            .resizable()
//                            .frame(width: 80, height: 80)
//                    }
//                    
//                    // App Title
//                    VStack(spacing: 8) {
//                        Text("Cryptsy")
//                            .font(.system(size: 28, weight: .bold, design: .rounded))
//                            .foregroundColor(Color.theme.accent)
//                        
//                        Text("Secure Portfolio Access")
//                            .font(.system(size: 16, weight: .medium, design: .rounded))
//                            .foregroundColor(Color.theme.secondaryText)
//                    }
//                }
//                
//                Spacer()
//                
//                // Authentication Section
//                VStack(spacing: 25) {
////                    if faceIDEnabled {
//                        // Face ID Button
////                        Button(action: {
//////                            authenticateWithFaceID()
////                        }) {
////                            HStack(spacing: 12) {
////                                Image(systemName: "faceid")
////                                    .font(.system(size: 24, weight: .medium))
////                                
////                                Text("Unlock with Face ID")
////                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
////                            }
////                            .foregroundColor(.white)
////                            .padding(.horizontal, 30)
////                            .padding(.vertical, 16)
////                            .background(
////                                LinearGradient(
////                                    gradient: Gradient(colors: [Color.theme.accent, Color.theme.accent.opacity(0.8)]),
////                                    startPoint: .leading,
////                                    endPoint: .trailing
////                                )
////                            )
////                            .clipShape(Capsule())
////                            .shadow(color: Color.theme.accent.opacity(0.3), radius: 10, x: 0, y: 5)
////                        }
//                        
//                        // Divider
////                        HStack {
////                            Rectangle()
////                                .fill(Color.theme.secondaryText.opacity(0.3))
////                                .frame(height: 1)
////                            
////                            Text("or")
////                                .font(.system(size: 14, weight: .medium, design: .rounded))
////                                .foregroundColor(Color.theme.secondaryText)
////                                .padding(.horizontal, 16)
////                            
////                            Rectangle()
////                                .fill(Color.theme.secondaryText.opacity(0.3))
////                                .frame(height: 1)
////                        }
////                        .padding(.horizontal, 40)
//                    }
//                    
//                    // Passcode Button
//                    Button(action: {
//                        showPasscodeSheet = true
//                    }) {
//                        HStack(spacing: 12) {
//                            Image(systemName: "lock.fill")
//                                .font(.system(size: 20, weight: .medium))
//                            
//                            Text("Enter Passcode")
//                                .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        }
//                        .foregroundColor(Color.theme.accent)
//                        .padding(.horizontal, 30)
//                        .padding(.vertical, 16)
//                        .background(
//                            RoundedRectangle(cornerRadius: 25)
//                                .fill(Color.theme.accent.opacity(0.1))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 25)
//                                        .stroke(Color.theme.accent.opacity(0.3), lineWidth: 1)
//                                )
//                        )
//                    }
//                }
//                
//                Spacer()
//                
//                // Footer
////                Text("Demo Passcode: 1234")
////                    .font(.system(size: 12, weight: .medium, design: .rounded))
////                    .foregroundColor(Color.theme.secondaryText.opacity(0.6))
////                    .padding(.bottom, 50)
//            }
//            .padding(.horizontal, 40)
//        }
//        .sheet(isPresented: $showPasscodeSheet) {
//            if #available(iOS 15.0, *) {
//                PasscodePromptView2(
//                    enteredPasscode: $enteredPasscode,
//                    correctPasscode: userPasscode,
//                    onConfirm: {
//                        if enteredPasscode == userPasscode {
//                            isLocked = false
//                        } else {
//                            enteredPasscode = ""
//                        }
//                    },
//                    onCancel: {
//                        showPasscodeSheet = false
//                        enteredPasscode = ""
//                    }
//                )
//            }
//        }
////        .onAppear {
////            if faceIDEnabled {
////                authenticateWithFaceID()
////            }
////        }
//    }
//    
////    private func authenticateWithFaceID() {
////        let context = LAContext()
////        var error: NSError?
////        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
////            let reason = "Unlock with Face ID"
////            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
////                                   localizedReason: reason) { success, _ in
////                DispatchQueue.main.async {
////                    if success {
////                        isLocked = false
////                    } else {
////                        enteredPasscode = ""
////                        showPasscodeSheet = true
////                    }
////                }
////            }
////        } else {
////            enteredPasscode = ""
////            showPasscodeSheet = true
////        }
////    }
//    
//    }
//}
import SwiftUI

struct LockView: View {
    @Binding var isLocked: Bool
    
    let userPasscode: String
    
    @State private var showPasscodeSheet = false
    @State private var enteredPasscode = ""
    
    var body: some View {
        ZStack {
            // Match app's background theme
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                // App Logo Section
                VStack(spacing: 30) {
                    // Logo with subtle glow
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.theme.accent.opacity(0.3),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 160, height: 160)
                        
                        Circle()
                            .fill(Color.white.opacity(0.95))
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.theme.accent.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Image("logo-transparent")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    
                    // App Title
                    VStack(spacing: 8) {
                        Text("Cryptsy")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color.theme.accent)
                        
                        Text("Secure Portfolio Access")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                
                Spacer()
                
                // Authentication Section
                VStack(spacing: 25) {
                    // Passcode Button
                    Button(action: {
                        showPasscodeSheet = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20, weight: .medium))
                            
                            Text("Enter Passcode")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(Color.theme.accent)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.theme.accent.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.theme.accent.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .sheet(isPresented: $showPasscodeSheet) {
            if #available(iOS 15.0, *) {
                PasscodePromptView2(
                    enteredPasscode: $enteredPasscode,
                    correctPasscode: userPasscode,
                    onConfirm: {
                        if enteredPasscode == userPasscode {
                            isLocked = false
                        } else {
                            enteredPasscode = ""
                        }
                    },
                    onCancel: {
                        showPasscodeSheet = false
                        enteredPasscode = ""
                    }
                )
            }
        }
    }
}
