import AVFoundation
import Foundation

enum SoundEffect {
    case letterButton
    case wheelSpin
    case timerFinished
}

@MainActor
final class SoundEffectPlayer {
    static let shared = SoundEffectPlayer()

    private var players: [AVAudioPlayer] = []

    private init() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.ambient)
        try? session.setActive(true)
    }

    func play(_ effect: SoundEffect) {
        players.removeAll { !$0.isPlaying }

        guard let player = try? AVAudioPlayer(data: waveData(for: effect)) else { return }
        player.volume = 0.75
        player.prepareToPlay()
        player.play()
        players.append(player)
    }

    private func waveData(for effect: SoundEffect) -> Data {
        let sampleRate: UInt32 = 44_100
        let samples = samples(for: effect, sampleRate: Double(sampleRate))
        let dataSize = UInt32(samples.count * MemoryLayout<Int16>.size)

        var data = Data()
        data.append("RIFF".data(using: .ascii)!)
        append(36 + dataSize, to: &data)
        data.append("WAVEfmt ".data(using: .ascii)!)
        append(UInt32(16), to: &data)
        append(UInt16(1), to: &data)
        append(UInt16(1), to: &data)
        append(sampleRate, to: &data)
        append(sampleRate * 2, to: &data)
        append(UInt16(2), to: &data)
        append(UInt16(16), to: &data)
        data.append("data".data(using: .ascii)!)
        append(dataSize, to: &data)

        for sample in samples {
            append(sample, to: &data)
        }

        return data
    }

    private func samples(for effect: SoundEffect, sampleRate: Double) -> [Int16] {
        let duration: Double

        switch effect {
        case .letterButton:
            duration = 0.10
        case .wheelSpin:
            duration = 1.10
        case .timerFinished:
            duration = 0.60
        }

        return (0..<Int(duration * sampleRate)).map { index in
            let time = Double(index) / sampleRate
            let sample: Double

            switch effect {
            case .letterButton:
                let envelope = max(0, 1 - time / duration)
                sample = sin(2 * .pi * 720 * time) * envelope * 0.22

            case .wheelSpin:
                let progress = time / duration
                let frequency = 180 + 520 * progress
                let envelope = sin(.pi * progress)
                sample = (
                    sin(2 * .pi * frequency * time)
                    + 0.22 * sin(2 * .pi * frequency * 1.92 * time)
                ) * envelope * 0.13

            case .timerFinished:
                let noteDuration = 0.20
                let noteIndex = min(Int(time / noteDuration), 2)
                let frequencies = [659.25, 783.99, 1_046.5]
                let noteTime = time.truncatingRemainder(dividingBy: noteDuration)
                let envelope = max(0, 1 - noteTime / noteDuration)
                sample = sin(2 * .pi * frequencies[noteIndex] * time) * envelope * 0.26
            }

            let clamped = max(-1, min(1, sample))
            return Int16(clamped * Double(Int16.max))
        }
    }

    private func append<T: FixedWidthInteger>(_ value: T, to data: inout Data) {
        var littleEndianValue = value.littleEndian
        withUnsafeBytes(of: &littleEndianValue) {
            data.append(contentsOf: $0)
        }
    }
}
