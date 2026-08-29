import SwiftUI

struct LettersView: View {
    @Environment(GameViewModel.self) private var viewModel

    private let columns = [GridItem(.adaptive(minimum: 56), spacing: 12)]

    var body: some View {
        ZStack {
            background
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    Text("Lettres")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                    section(
                        title: "Déjà tirées",
                        count: viewModel.used.count,
                        letters: viewModel.used,
                        isUsed: true
                    )
                    section(
                        title: "Pas encore tirées",
                        count: viewModel.remaining.count,
                        letters: viewModel.remaining,
                        isUsed: false
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.33, blue: 0.85),
                    Color(red: 0.27, green: 0.32, blue: 0.87)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 260)
                .offset(x: 170, y: -300)
        }
        .ignoresSafeArea()
    }

    private func section(title: String, count: Int, letters: [String], isUsed: Bool) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("\(count)")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.white.opacity(isUsed ? 0.35 : 0.2)))
            }
            if letters.isEmpty {
                Text(isUsed ? "Aucune lettre tirée pour l'instant." : "Toutes les lettres ont été tirées !")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 14)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(letters, id: \.self) { letter in
                        Text(letter)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(isUsed ? .white : Color(red: 0.45, green: 0.38, blue: 0.9))
                            .frame(width: 56, height: 56)
                            .background(
                                Circle().fill(isUsed ? Color(red: 0.95, green: 0.45, blue: 0.65) : .white)
                            )
                            .shadow(color: .black.opacity(isUsed ? 0.15 : 0.08), radius: 6, y: 3)
                    }
                }
            }
        }
    }
}

#Preview {
    LettersView()
        .environment(GameViewModel())
}
