import Foundation
import Observation
import SwiftUI

@Observable
final class GameViewModel {
    let allLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init)

    private(set) var remaining: [String]
    private(set) var used: [String] = []
    private(set) var selected: String?
    private(set) var isSpinning = false
    private(set) var wheelRotation: Double = 0

    private var spinToken = UUID()

    init() {
        remaining = allLetters
    }

    func spin() {
        guard !isSpinning, !remaining.isEmpty else { return }
        let token = UUID()
        spinToken = token
        isSpinning = true
        selected = nil

        let index = Int.random(in: 0..<remaining.count)
        let step = 360.0 / Double(remaining.count)
        var remainder = (-Double(index) * step).truncatingRemainder(dividingBy: 360)
        if remainder < 0 { remainder += 360 }
        let turns = Double(Int.random(in: 5...8)) * 360
        let target = wheelRotation + turns + remainder

        withAnimation(.easeInOut(duration: 2.3)) {
            wheelRotation = target
        }

        Task {
            try? await Task.sleep(for: .seconds(2.35))
            guard token == spinToken else { return }
            let letter = remaining.remove(at: index)
            used.append(letter)
            selected = letter
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                isSpinning = false
            }
        }
    }

    func reset() {
        spinToken = UUID()
        isSpinning = false
        selected = nil
        withAnimation(.easeOut(duration: 0.4)) {
            wheelRotation = 0
        }
        remaining = allLetters
        used = []
    }
}
