import SwiftUI

extension Location {
    struct LocationPicker: View {
        @Environment(\.dismiss) var dismiss
        
        @Binding var selectedLocation: String

        @FocusState private var textFieldFocused
        
        var body: some View {
            VStack {
                TextField("Enter location", text: $selectedLocation)
                    .focused($textFieldFocused)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.secondary, lineWidth: 1)
                    }
                    .padding()

                Button("Done") {
                    textFieldFocused = false
                    dismiss()
                }
            }
            .padding(48)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .onAppear {
                textFieldFocused = true
            }
        }
    }
}

#Preview {
    @Previewable
    @State var selectedLocation = "32601"
    Location.LocationPicker(selectedLocation: $selectedLocation)
}
