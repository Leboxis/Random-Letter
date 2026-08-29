import Foundation
import SwiftUI

struct AboutView: View {
    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.3"
    }

    var body: some View {
        ZStack {
            background
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "sparkles")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 96, height: 96)
                    .background(Circle().fill(Color.white.opacity(0.16)))

                Text("Random Letter")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Text("La roulette du petit bac")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))

                VStack(spacing: 6) {
                    Text("Créé par")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.75))
                    Text("KediBoyy")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.white.opacity(0.14)))
                .padding(.horizontal, 36)

                Text("Version \(version)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.75))
                Spacer()
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
        }
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.27, green: 0.32, blue: 0.87),
                    Color(red: 0.55, green: 0.33, blue: 0.85),
                    Color(red: 0.88, green: 0.42, blue: 0.62)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 280)
                .offset(x: -150, y: -310)
            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 220)
                .offset(x: 160, y: 330)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AboutView()
}
