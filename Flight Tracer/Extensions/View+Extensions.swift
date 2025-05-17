import SwiftUI

struct CustomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent()
                    .presentationDetents([.fraction(0.65)])
                    .presentationCornerRadius(25)
            }
    }
}

extension View {
    func premiumSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(CustomSheetModifier(isPresented: isPresented, sheetContent: content))
    }
}

#Preview {
    AuthenticatedView()
}
