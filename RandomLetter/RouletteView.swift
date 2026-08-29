import SwiftUI

struct RouletteView: View {
    @Environment(GameViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                header
                Spacer()
                wheelSection
                Spacer()
                controls
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
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
                .offset(x: -150, y: -330)
            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 220)
                .offset(x: 170, y: 350)
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Random Letter")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            Text("La roulette du petit bac")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding(.top, 14)
    }

    private var wheelSection: some View {
        ZStack {
            wheel
            if let letter = viewModel.selected {
                selectedCard(letter)
            }
        }
        .frame(width: 300, height: 300)
    }

    private var wheel: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
            Circle()
                .stroke(Color.white.opacity(0.4), lineWidth: 3)
            ForEach(Array(viewModel.remaining.enumerated()), id: \.element) { index, letter in
                let step = 360.0 / Double(max(viewModel.remaining.count, 1))
                let angle = (Double(index) * step - 90) * .pi / 180
                Text(letter)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.white.opacity(0.28)))
                    .rotationEffect(.degrees(-viewModel.wheelRotation))
                    .position(x: 150 + cos(angle) * 120, y: 150 + sin(angle) * 120)
            }
        }
        .frame(width: 300, height: 300)
        .rotationEffect(.degrees(viewModel.wheelRotation))
    }

    private func selectedCard(_ letter: String) -> some View {
        VStack(spacing: 4) {
            Text("Ta lettre")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.9))
            Text(letter)
                .font(.system(size: 110, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.42, green: 0.35, blue: 0.95),
                            Color(red: 0.95, green: 0.45, blue: 0.65)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .frame(width: 230, height: 230)
        .background(RoundedRectangle(cornerRadius: 36, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.25), radius: 24, y: 10)
        .scaleEffect(viewModel.selected == nil ? 0.001 : 1)
        .opacity(viewModel.selected == nil ? 0 : 1)
        .animation(.spring(response: 0.5, dampingFraction: 0.65), value: viewModel.selected)
    }

    private var controls: some View {
        VStack(spacing: 16) {
            Button(action: { viewModel.spin() }) {
                HStack(spacing: 10) {
                    Image(systemName: "dice.fill")
                    Text(viewModel.remaining.isEmpty ? "Roulette terminée" : "Tirer une lettre")
                }
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.9))
                .padding(.horizontal, 36)
                .padding(.vertical, 16)
                .background(Capsule().fill(.white))
                .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
            }
            .disabled(viewModel.isSpinning || viewModel.remaining.isEmpty)
            .opacity(viewModel.isSpinning ? 0.6 : 1)

            Button(action: { viewModel.reset() }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    Text("Réinitialiser")
                }
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.white.opacity(0.2)))
            }
            .disabled(viewModel.isSpinning)

            Text("\(viewModel.remaining.count) lettre(s) restante(s)")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
        }
        .padding(.bottom, 14)
    }
}

#Preview {
    RouletteView()
        .environment(GameViewModel())
}
