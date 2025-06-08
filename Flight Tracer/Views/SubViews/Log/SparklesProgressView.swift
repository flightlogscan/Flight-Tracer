import SwiftUI

struct SparklesProgressView: View {
    @State private var currentMessageIndex: Int = 0

    private let messages: [String] = [
        "Feeling the need for speeding through logs…",
        "Scanning in under 12 parsecs…",
        "That's the way he scans: ice cold…",
        "A pig that doesn't scan logs is just a pig…",
        "The log is long, but distinguished...",
        "Setting the laser from stun to scan…",
        "If it's got logs I can scan it…"
    ]

    private let messageTimer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()

    private let aiGradientColors: [Color] = [.indigo, .blue]
    private let sparkleGradientColors: [Color] = [.indigo, .blue]
    private let loaderLineWidth: CGFloat = 4.0
    private let sparkleSymbolSize: CGFloat = 35.0
    private let circularLoaderDiameter: CGFloat = 60.0

    var body: some View {
        VStack {
            Text(messages[currentMessageIndex])
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.25), lineWidth: loaderLineWidth)
                    .frame(width: circularLoaderDiameter, height: circularLoaderDiameter)
                RotatingArc(
                    gradientColors: aiGradientColors,
                    lineWidth: loaderLineWidth,
                    diameter: circularLoaderDiameter
                )
                Image(systemName: "sparkles")
                    .font(.system(size: sparkleSymbolSize))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: sparkleGradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: sparkleSymbolSize, height: sparkleSymbolSize)
            }
        }
        .onReceive(messageTimer) { _ in
            currentMessageIndex = Int.random(in: 0..<messages.count)
        }
    }
}

private struct RotatingArc: View {
    let gradientColors: [Color]
    let lineWidth: CGFloat
    let diameter: CGFloat
    @State private var angle: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.75)
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .frame(width: diameter, height: diameter)
            .rotationEffect(.degrees(angle))
            .onAppear {
                withAnimation(.linear(duration: 1.35).repeatForever(autoreverses: false)) {
                    angle = 360
                }
            }
    }
}

struct SparklesProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            SparklesProgressView()
        }
        .previewDisplayName("SparklesProgressView")
    }
}
