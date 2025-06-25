import SwiftUI
import UIKit

struct PasscodePromptView2: View {
    @Binding var enteredPasscode: String
    let correctPasscode: String
    var onConfirm: () -> Void
    var onCancel: () -> Void

    @State private var showError = false

    var body: some View {
        VStack {
            Spacer()
            
            Text("Enter 4-Digit Passcode")
                .font(.headline)
                .padding(.top, 20)

            // 4 dots visualization
            HStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(index < enteredPasscode.count ? .primary : .gray)
                }
            }
            .padding(.vertical, 20)

            // Error message
            if showError {
                Text("Incorrect Passcode")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom, 10)
            }

            // Hidden text field that forces numeric keypad
            NumericKeypadTextField(
                text: $enteredPasscode,
                maxLength: 4,
                onTextChange: { _ in
                    showError = false
                }
            )
            .frame(width: 1, height: 1) // Make it tiny but still focusable
            .opacity(0.01) // Nearly invisible

            Spacer()

            // Buttons
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .foregroundColor(.red)
                .padding(.horizontal)

                Spacer()

                Button("OK") {
                    if enteredPasscode == correctPasscode {
                        onConfirm()
                    } else {
                        showError = true
                        enteredPasscode = ""
                    }
                }
                .foregroundColor(.blue)
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .contentShape(Rectangle()) // Make entire view tappable
        .onTapGesture {
            // Tap anywhere to focus the hidden text field
            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - UIViewRepresentable for Numeric Keypad
struct NumericKeypadTextField: UIViewRepresentable {
    @Binding var text: String
    let maxLength: Int
    let onTextChange: (String) -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.textColor = UIColor.clear
        textField.backgroundColor = UIColor.clear
        textField.tintColor = UIColor.clear
        textField.borderStyle = .none
        textField.delegate = context.coordinator
        
        // Auto-focus when created
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
        }
        
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: NumericKeypadTextField

        init(_ parent: NumericKeypadTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Only allow numeric characters
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }

            // Calculate new text
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Limit to max length
            if updatedText.count <= parent.maxLength {
                parent.text = updatedText
                parent.onTextChange(updatedText)
                return true
            }
            
            return false
        }
    }
}
