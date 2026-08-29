import SwiftUI

struct TimerPickerView: View {
    static let durations = [30, 60, 90, 120, 180, 300]

    @Environment(\.dismiss) private var dismiss
    @State private var selectedDuration: Int
    private let onSelect: (Int?) -> Void

    init(duration: Int?, onSelect: @escaping (Int?) -> Void) {
        _selectedDuration = State(initialValue: duration ?? 0)
        self.onSelect = onSelect
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Choisis le temps de la manche")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                Text("Le chronomètre est désactivé par défaut.")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Picker("Durée", selection: $selectedDuration) {
                    Text("Désactivé").tag(0)

                    ForEach(Self.durations, id: \.self) { duration in
                        Text(duration.timerText)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .tag(duration)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 210)
                .sensoryFeedback(.selection, trigger: selectedDuration)
                .onChange(of: selectedDuration) { _, duration in
                    onSelect(duration == 0 ? nil : duration)
                }

                Spacer()
            }
            .navigationTitle("Chronomètre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Terminé") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

extension Int {
    var timerText: String {
        String(format: "%02d:%02d", self / 60, self % 60)
    }
}
