//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Appearance
    @AppStorage("isDarkMode") private var isDarkMode = false

    // MARK: - Security
    @AppStorage("userPasscode") private var userPasscode: String = "1234"
    @State private var showChangePasscodeSheet = false

    // MARK: - Notification Settings
    @AppStorage("transactionAlerts") private var transactionAlerts = false
    @AppStorage("priceChangeAlerts") private var priceChangeAlerts = false
    @AppStorage("securityNotifications") private var securityNotifications = false

    // MARK: - Language & Currency
    private let languages = ["English", "Spanish", "French", "German", "Hindi"]
    private let currencies = ["USD", "EUR", "INR"]
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    @AppStorage("appCurrency") private var appCurrency: String = "USD"
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
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
                    LazyVStack(spacing: 20) {
                        // Header
                        headerSection
                            .padding(.top, 20)
                        
                        // Security Section
                        modernSection(
                            title: "🔐 Security",
                            content: securitySection
                        )
                        
                        // Notifications Section
                        modernSection(
                            title: "🔔 Notifications",
                            content: notificationSection
                        )
                        
                        // Preferences Section
                        modernSection(
                            title: "⚙️ Preferences",
                            content: languageCurrencySection
                        )
                        
                        // Appearance Section
                        modernSection(
                            title: "🎨 Appearance",
                            content: appearanceSection
                        )
                        
                        // Data Source Section
                        modernSection(
                            title: "📊 Data Source",
                            content: apiServiceSection
                        )
                        
                        // About App Section
                        modernSection(
                            title: "📱 About App",
                            content: aboutAppSection
                        )
                        
                        // About Developer Section
                        modernSection(
                            title: "👨‍💻 Developer",
                            content: aboutDeveloperSection
                        )
                        
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 16))
                        Text("Home")
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
            )
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .sheet(isPresented: $showChangePasscodeSheet) {
            if #available(iOS 15.0, *) {
                ChangePasscodeView(
                    currentPasscode: userPasscode,
                    onPasscodeChanged: { newPasscode in
                        userPasscode = newPasscode
                        showChangePasscodeSheet = false
                    },
                    onCancel: { showChangePasscodeSheet = false }
                )
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

// MARK: - Sections
extension SettingsView {
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 4) {
                Text("App Settings")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.accent)
                
                Text("Customize your crypto experience")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
    
    private func modernSection<Content: View>(title: String, content: Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color.theme.accent)
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
    
    private var securitySection: some View {
        VStack(spacing: 0) {
            modernSettingRow(
                icon: "🔑",
                title: "Change Passcode",
                subtitle: "Update your security passcode",
                action: {
                    showChangePasscodeSheet = true
                }
            )
        }
        .padding(.horizontal, 20)
    }

    private var notificationSection: some View {
        VStack(spacing: 12) {
            modernToggleRow(
                icon: "💰",
                title: "Transaction Alerts",
                subtitle: "Get notified about portfolio changes",
                isOn: $transactionAlerts
            )
            
            Divider()
                .padding(.horizontal, 20)
            
            modernToggleRow(
                icon: "📈",
                title: "Price Change Alerts",
                subtitle: "Monitor significant price movements",
                isOn: $priceChangeAlerts
            )
            
            Divider()
                .padding(.horizontal, 20)
            
            modernToggleRow(
                icon: "🛡️",
                title: "Security Notifications",
                subtitle: "Security and account updates",
                isOn: $securityNotifications
            )
        }
        .padding(.horizontal, 20)
    }

    private var languageCurrencySection: some View {
        VStack(spacing: 12) {
            modernPickerRow(
                icon: "🌍",
                title: "App Language",
                subtitle: "Choose your preferred language",
                selection: $appLanguage,
                options: languages
            )
            
            Divider()
                .padding(.horizontal, 20)
            
            modernPickerRow(
                icon: "💱",
                title: "Display Currency",
                subtitle: "Set your default currency",
                selection: $appCurrency,
                options: currencies
            )
        }
        .padding(.horizontal, 20)
    }

    private var appearanceSection: some View {
        VStack(spacing: 0) {
            modernToggleRow(
                icon: "🌙",
                title: "Dark Mode",
                subtitle: "Switch between light and dark themes",
                isOn: $isDarkMode
            )
        }
        .padding(.horizontal, 20)
    }

    private var apiServiceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text("🔗")
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Powered by CoinGecko API")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text("Real-time cryptocurrency market data")
                        .font(.system(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
            }
            
            Button(action: {
                if let url = URL(string: "https://www.coingecko.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "safari.fill")
                        .font(.system(size: 14))
                    Text("Visit CoinGecko")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green, Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 20)
    }

    private var aboutAppSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "bitcoinsign.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cryptsy")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text("Version 1.0.0")
                        .font(.system(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("🚀 Your crypto companion")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.blue)
                }
                
                Spacer()
            }
            
            Text("A simple, powerful crypto tracker and portfolio app. Track real-time prices, manage your holdings, and stay updated—all in one sleek, easy-to-use dashboard.")
                .font(.system(size: 14))
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(nil)
        }
        .padding(.horizontal, 20)
    }

    private var aboutDeveloperSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Arnav Adarsh")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text("BTech, IIIT Delhi")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("❤️ Developed with Swift")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.red)
                }
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                modernContactRow(
                    icon: "✉️",
                    title: "Email",
                    subtitle: "arnavadarsh@icloud.com",
                    action: {
                        if let url = URL(string: "mailto:arnavadarsh@icloud.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                modernContactRow(
                    icon: "💼",
                    title: "LinkedIn",
                    subtitle: "Professional Profile",
                    action: {
                        if let url = URL(string: "https://www.linkedin.com/in/arnav-adarsh-a68552290/") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                modernContactRow(
                    icon: "📸",
                    title: "Instagram",
                    subtitle: "@arnavadarsh_",
                    action: {
                        if let url = URL(string: "https://www.instagram.com/arnavadarsh_?igsh=MTY0Yml1aXg3dW5qbA%3D%3D&utm_source=qr") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                modernContactRow(
                    icon: "⭐",
                    title: "Rate this App",
                    subtitle: "Share your feedback",
                    action: {
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id/your-app-id?action=write-review") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Helper Views
    
    private func modernSettingRow(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(icon)
                    .font(.system(size: 24))
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func modernToggleRow(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 16) {
            Text(icon)
                .font(.system(size: 24))
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.theme.accent)
                    .multilineTextAlignment(.leading)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .scaleEffect(0.9)
        }
        .padding(.vertical, 8)
    }
    
    private func modernPickerRow(icon: String, title: String, subtitle: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                Text(icon)
                    .font(.system(size: 24))
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                Text(selection.wrappedValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
            }
            
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.vertical, 8)
    }
    
    private func modernContactRow(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(icon)
                    .font(.system(size: 20))
                    .frame(width: 28, height: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ChangePasscodeView (Enhanced)
@available(iOS 15.0, *)
struct ChangePasscodeView: View {
    let currentPasscode: String
    var onPasscodeChanged: (String) -> Void
    var onCancel: () -> Void
    
    @State private var oldPasscode = ""
    @State private var newPasscode = ""
    @State private var confirmPasscode = ""
    @State private var currentStep = 0
    @State private var showError = false
    @State private var errorMessage = ""
    
    @FocusState private var passcodeFieldFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
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
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        Text(stepTitle)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color.theme.accent)
                            .multilineTextAlignment(.center)
                        
                        // Updated instruction text based on current step
                        Text(instructionText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 30) {
                        HStack(spacing: 20) {
                            ForEach(0..<4, id: \.self) { index in
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(
                                        index < currentPasscodeText.count
                                            ? Color.blue
                                            : Color.gray.opacity(0.3)
                                    )
                                    .scaleEffect(index < currentPasscodeText.count ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7),
                                               value: currentPasscodeText.count)
                            }
                        }
                        
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // Always visible text field to maintain keypad
                    TextField("", text: currentPasscodeBinding)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                        .focused($passcodeFieldFocused)
                        .onChange(of: currentPasscodeBinding.wrappedValue) { newValue in
                            let filtered = String(newValue.filter { $0.isNumber }.prefix(4))
                            currentPasscodeBinding.wrappedValue = filtered
                            showError = false
                            
                            if filtered.count == 4 {
                                handlePasscodeEntry()
                            }
                        }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button("Cancel") {
                            onCancel()
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.1))
                        )
                        
                        Spacer()
                        
                        if currentStep > 0 {
                            Button("Back") {
                                goToPreviousStep()
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.1))
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Change Passcode")
            .navigationBarTitleDisplayMode(.inline)
            .contentShape(Rectangle())
            .onTapGesture {
                // Re-focus when tapping anywhere
                passcodeFieldFocused = true
            }
            .onAppear {
                // Auto-focus when view appears
                DispatchQueue.main.async {
                    passcodeFieldFocused = true
                }
            }
        }
    }
    
    private var stepTitle: String {
        switch currentStep {
        case 0: return "Enter Current\nPasscode"
        case 1: return "Enter New\nPasscode"
        case 2: return "Confirm New\nPasscode"
        default: return ""
        }
    }
    
    private var instructionText: String {
        switch currentStep {
        case 0: return "Please enter your current 4-digit passcode"
        case 1: return "Please enter your new 4-digit passcode"
        case 2: return "Please confirm your new passcode"
        default: return ""
        }
    }
    
    private var currentPasscodeText: String {
        switch currentStep {
        case 0: return oldPasscode
        case 1: return newPasscode
        case 2: return confirmPasscode
        default: return ""
        }
    }
    
    private var currentPasscodeBinding: Binding<String> {
        switch currentStep {
        case 0: return $oldPasscode
        case 1: return $newPasscode
        case 2: return $confirmPasscode
        default: return $oldPasscode
        }
    }
    
    private func handlePasscodeEntry() {
        switch currentStep {
        case 0:
            if oldPasscode == currentPasscode {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) {
                        currentStep = 1
                        newPasscode = ""
                        // Keep focus on text field
                        passcodeFieldFocused = true
                    }
                }
            } else {
                showError = true
                errorMessage = "Incorrect passcode. Please try again."
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    oldPasscode = ""
                    // Keep focus on text field
                    passcodeFieldFocused = true
                }
            }
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    currentStep = 2
                    confirmPasscode = ""
                    // Keep focus on text field
                    passcodeFieldFocused = true
                }
            }
        case 2:
            if confirmPasscode == newPasscode {
                onPasscodeChanged(newPasscode)
            } else {
                showError = true
                errorMessage = "Passcodes don't match. Please try again."
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    confirmPasscode = ""
                    // Keep focus on text field
                    passcodeFieldFocused = true
                }
            }
        default:
            break
        }
    }
    
    private func goToPreviousStep() {
        withAnimation(.spring()) {
            currentStep -= 1
            showError = false
            
            switch currentStep {
            case 0:
                newPasscode = ""
                oldPasscode = ""
            case 1:
                confirmPasscode = ""
            default:
                break
            }
            
            // Keep focus on text field
            DispatchQueue.main.async {
                passcodeFieldFocused = true
            }
        }
    }
}
// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
