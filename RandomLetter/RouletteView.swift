import SwiftUI

struct RouletteView: View {
    @Environment(GameViewModel.self) private var viewModel
    @State private var selectedCardScale = 0.1
    @State private var isTimerPickerPresented = false
    @State private var isCategoryIdeasPresented = false

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
        .sheet(isPresented: $isTimerPickerPresented) {
            TimerPickerView(duration: viewModel.selectedDuration) { duration in
                viewModel.setDuration(duration)
            }
        }
        .sheet(isPresented: $isCategoryIdeasPresented) {
            CategoryIdeasView()
        }
        .onChange(of: viewModel.selected) { _, selectedLetter in
            guard selectedLetter != nil else {
                selectedCardScale = 0.1
                return
            }

            selectedCardScale = 0.1
            withAnimation(.spring(response: 0.52, dampingFraction: 0.62).delay(0.05)) {
                selectedCardScale = 1
            }
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
        ZStack {
            VStack(spacing: 3) {
                Text("Random Letter")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Text("La roulette du petit bac")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))

                if let timeRemaining = viewModel.timeRemaining {
                    Text(timeRemaining.timerText)
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.snappy, value: timeRemaining)
                        .accessibilityLabel("Chronomètre : \(timeRemaining.timerText)")
                }
            }
            .frame(maxWidth: .infinity)

            HStack {
                roundHeaderButton(systemImage: "timer", action: {
                    isTimerPickerPresented = true
                })
                .accessibilityLabel("Choisir le temps")

                Spacer()

                roundHeaderButton(systemImage: "rectangle.grid.2x2.fill", action: {
                    isCategoryIdeasPresented = true
                })
                .accessibilityLabel("Voir les idées de catégories")
            }
        }
        .padding(.top, 14)
    }

    private func roundHeaderButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.9))
                .frame(width: 44, height: 44)
                .background(Circle().fill(.white))
                .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
        }
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
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.9))
            Text(letter)
                .font(.system(size: 94, weight: .black, design: .rounded))
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
        .frame(width: 190, height: 190)
        .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.25), radius: 20, y: 8)
        .scaleEffect(selectedCardScale)
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
