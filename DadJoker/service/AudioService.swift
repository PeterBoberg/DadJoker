//
// Created by Peter Boberg on 2017-12-11.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import AVFoundation

class AudioService {

    public static let shared = AudioService()

    private let session = AVAudioSession.sharedInstance()
    private var player: AVAudioPlayer?

    private init() {

    }

    func playSound(filename: String) {
        print("Playing sound")
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Could not locate file")
            return
        }

        play(url: fileUrl, fileType: .mp3)

    }

    func playRandomLaugh() {
        let sounds = ["laugh_small", "laugh_small2", "laugh_big"]
        let random = Int(arc4random_uniform(UInt32(sounds.count)))
        guard  let fileUrl = Bundle.main.url(forResource: sounds[random], withExtension: "mp3") else {
            print("Could not locate file")
            return
        }
        play(url: fileUrl, fileType: .mp3)
    }

    private func play(url: URL, fileType: AVFileType) {
        do {
            print(url)
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: fileType.rawValue)
            player?.play()

        } catch let error {
            print(error.localizedDescription)
        }

    }
}
