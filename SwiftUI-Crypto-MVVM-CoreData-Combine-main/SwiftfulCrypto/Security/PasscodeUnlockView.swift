//import SwiftUI
//
//struct PasscodeUnlockView: View {
//    @Binding var isLocked: Bool
//    let userPasscode: String
//    @State private var enteredPasscode = ""
//    @State private var showError = false
//    @State private var refreshKey = UUID()
//    
//    // Dynamic theming
//    @AppStorage("isDarkMode") private var isDarkMode = false
//    
//    var body: some View {
//        ZStack {
//            // Dynamic background color
//            (isDarkMode ? Color.black : Color.white)
//                .ignoresSafeArea()
//            
//            VStack(spacing: 40) {
//                Spacer()
//                
//                // App Logo
//                VStack(spacing: 20) {
//                    Image(systemName: "bitcoinsign.circle.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 80, height: 80)
//                        .foregroundColor(Color.theme.accent)
//                    
//                    Text("Cryptsy")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(isDarkMode ? .white : .black)
//                }
//                
//                Spacer()
//                
//                // Passcode Entry Section
//                VStack(spacing: 30) {
//                    Text("Enter Passcode")
//                        .font(.title2)
//                        .fontWeight(.medium)
//                        .foregroundColor(isDarkMode ? .white : .black)
//                    
//                    // 4 dots visualization
//                    HStack(spacing: 20) {
//                        ForEach(0..<4, id: \.self) { index in
//                            Circle()
//                                .frame(width: 15, height: 15)
//                                .foregroundColor(
//                                    index < enteredPasscode.count ?
//                                    Color.theme.accent :
//                                    (isDarkMode ? Color.gray : Color.gray.opacity(0.5))
//                                )
//                        }
//                    }
//                    
//                    if showError {
//                        Text("Wrong Passcode")
//                            .foregroundColor(.red)
//                            .font(.caption)
//                            .fontWeight(.medium)
//                    }
//                }
//                
//                // Hidden text field for passcode entry
//                PasscodeTextField(
//                    text: $enteredPasscode,
//                    onTextChange: { newValue in
//                        showError = false
//                        if newValue.count == 4 {
//                            verifyPasscode()
//                        }
//                    }
//                )
//                .frame(width: 1, height: 1)
//                .opacity(0.01)
//                .id(refreshKey)
//                
//                Spacer()
//                Spacer()
//            }
//        }
//        .contentShape(Rectangle())
//        .onTapGesture {
//            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
//        }
//        .preferredColorScheme(isDarkMode ? .dark : .light)
//    }
//    
//    private func verifyPasscode() {
//        if enteredPasscode == userPasscode {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                isLocked = false
//            }
//        } else {
//            // Wrong passcode with shake animation
//            withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
//                showError = true
//            }
//            
//            // Clear passcode after a short delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                enteredPasscode = ""
//                showError = false
//                refreshKey = UUID()
//            }
//        }
//    }
//}
//
//// MARK: - PasscodeTextField (Separate from NumericKeypadTextField)
//struct PasscodeTextField: UIViewRepresentable {
//    @Binding var text: String
//    let onTextChange: (String) -> Void
//    
//    func makeUIView(context: Context) -> UITextField {
//        let textField = UITextField()
//        textField.keyboardType = .numberPad
//        textField.isSecureTextEntry = true
//        textField.textColor = UIColor.clear
//        textField.backgroundColor = UIColor.clear
//        textField.tintColor = UIColor.clear
//        textField.borderStyle = .none
//        textField.delegate = context.coordinator
//        
//        DispatchQueue.main.async {
//            textField.becomeFirstResponder()
//        }
//        
//        return textField
//    }
//    
//    func updateUIView(_ uiView: UITextField, context: Context) {
//        if uiView.text != text {
//            uiView.text = text
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, UITextFieldDelegate {
//        let parent: PasscodeTextField
//        
//        init(_ parent: PasscodeTextField) {
//            self.parent = parent
//        }
//        
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            
//            if !allowedCharacters.isSuperset(of: characterSet) {
//                return false
//            }
//            
//            let currentText = textField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//            
//            if updatedText.count <= 4 {
//                parent.text = updatedText
//                parent.onTextChange(updatedText)
//                return true
//            }
//            
//            return false
//        }
//    }
//}
//
//struct PasscodeUnlockView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasscodeUnlockView(isLocked: .constant(true), userPasscode: "1234")
//    }
//}
