//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Arnav Adarsh on 5/5/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    // MARK: - Profile Data
    @AppStorage("firstName") private var firstName: String = "John"
    @AppStorage("lastName") private var lastName: String = "Doe"
    @AppStorage("profileImageData") private var profileImageData: Data?
    @AppStorage("userEmail") private var userEmail: String = "user@example.com"
    @AppStorage("userPhone") private var userPhone: String = "+1 234 567 8900"
    @AppStorage("userAge") private var userAge: String = "25"
    @AppStorage("accountId") private var accountId: String = UUID().uuidString
    
    // MARK: - UI State
    @State private var showImagePicker = false
    @State private var showImageOptions = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.presentationMode) var presentationMode
    
    // Computed property for full name (for HomeView compatibility)
    private var fullName: String {
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
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
                    LazyVStack(spacing: 24) {
                        // Enhanced Profile Header
                        profileHeaderSection
                            .padding(.top, 20)
                        
                        // Personal Information Section
                        modernSection(
                            title: "👤 Personal Information",
                            content: personalInfoSection
                        )
                        
                        // Account Information Section
                        modernSection(
                            title: "🏦 Account Information",
                            content: accountInfoSection
                        )
                        
                        // Quick Actions Section
                        modernSection(
                            title: "⚡ Quick Actions",
                            content: quickActionsSection
                        )
                        
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("My Profile")
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
                },
                trailing: Button("Save") {
                    // Save profile action
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green, Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
            )
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImageData: $profileImageData)
        }
        .actionSheet(isPresented: $showImageOptions) {
            ActionSheet(
                title: Text("Profile Photo"),
                message: Text("Choose how you'd like to update your profile photo"),
                buttons: [
                    .default(Text("📷 Take Photo")) {
                        // Camera option
                    },
                    .default(Text("🖼️ Choose from Library")) {
                        showImagePicker = true
                    },
                    .destructive(Text("🗑️ Remove Photo")) {
                        profileImageData = nil
                    },
                    .cancel()
                ]
            )
        }
        .onAppear {
            // Update userName for HomeView compatibility
            UserDefaults.standard.set(fullName, forKey: "userName")
        }
        .onChange(of: firstName) { _ in
            UserDefaults.standard.set(fullName, forKey: "userName")
        }
        .onChange(of: lastName) { _ in
            UserDefaults.standard.set(fullName, forKey: "userName")
        }
    }
}

// MARK: - Profile Sections
extension ProfileView {
    
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
    
    private var profileHeaderSection: some View {
        VStack(spacing: 24) {
            // Profile Picture with enhanced styling
            VStack(spacing: 16) {
                Button(action: {
                    showImageOptions = true
                }) {
                    ZStack {
                        if let data = profileImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 4
                                        )
                                )
                                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
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
                                    .frame(width: 140, height: 140)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Camera icon overlay
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 36, height: 36)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.blue)
                                }
                                .offset(x: -10, y: -10)
                            }
                        }
                        .frame(width: 140, height: 140)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Enhanced display name and email
                VStack(spacing: 8) {
                    Text(fullName.isEmpty ? "Your Name" : fullName)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.theme.accent)
                        .shadow(color: Color.theme.accent.opacity(0.2), radius: 2, x: 0, y: 1)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Text(userEmail)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.1))
                    )
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
    
    private var personalInfoSection: some View {
        VStack(spacing: 16) {
            modernInputField(
                icon: "👤",
                title: "First Name",
                placeholder: "Enter first name",
                text: $firstName
            )
            
            modernInputField(
                icon: "👥",
                title: "Last Name",
                placeholder: "Enter last name",
                text: $lastName
            )
            
            modernInputField(
                icon: "✉️",
                title: "Email Address",
                placeholder: "Enter email address",
                text: $userEmail,
                keyboardType: .emailAddress
            )
            
            modernInputField(
                icon: "📱",
                title: "Phone Number",
                placeholder: "Enter phone number",
                text: $userPhone,
                keyboardType: .phonePad
            )
            
            modernInputField(
                icon: "🎂",
                title: "Age",
                placeholder: "Enter age",
                text: $userAge,
                keyboardType: .numberPad
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var accountInfoSection: some View {
        VStack(spacing: 16) {
            // Account ID with copy functionality
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Text("🆔")
                        .font(.system(size: 20))
                    Text("Account ID")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = accountId
                        // Add haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc.fill")
                                .font(.system(size: 12))
                            Text("Copy")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
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
                
                Text(accountId)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            // Member since with enhanced styling
            HStack(spacing: 12) {
                Text("📅")
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Member Since")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text("January 2024")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("120")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.blue)
                    
                    Text("Days Active")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                modernActionButton(
                    icon: "🔄",
                    title: "Sync Data",
                    subtitle: "Update profile",
                    color: .blue
                ) {
                    // Sync action
                }
                
                modernActionButton(
                    icon: "📤",
                    title: "Export Data",
                    subtitle: "Download CSV",
                    color: .green
                ) {
                    // Export action
                }
            }
            
            HStack(spacing: 12) {
                modernActionButton(
                    icon: "🔒",
                    title: "Security",
                    subtitle: "Privacy settings",
                    color: .orange
                ) {
                    // Security action
                }
                
                modernActionButton(
                    icon: "❓",
                    title: "Help",
                    subtitle: "Get support",
                    color: .purple
                ) {
                    // Help action
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Helper Views
    
    private func modernInputField(
        icon: String,
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.accent)
            }
            
            TextField(placeholder, text: text)
                .font(.system(size: 16, weight: .medium))
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
    
    private func modernActionButton(
        icon: String,
        title: String,
        subtitle: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Text(icon)
                        .font(.system(size: 20))
                }
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.accent)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
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
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ImagePicker (Enhanced)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let editedImage = info[.editedImage] as? UIImage,
               let data = editedImage.jpegData(compressionQuality: 0.8) {
                parent.selectedImageData = data
            } else if let originalImage = info[.originalImage] as? UIImage,
                      let data = originalImage.jpegData(compressionQuality: 0.8) {
                parent.selectedImageData = data
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
