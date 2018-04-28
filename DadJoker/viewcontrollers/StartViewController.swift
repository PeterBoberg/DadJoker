//
// Created by Peter Boberg on 2017-12-07.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var fortuneWheelView: FortuneWheelView!
    @IBOutlet weak var spinMeBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var multiColorView: UIView!

    // MARK: - Private fields
    private let appService = ApiService.shared
    private let audioService = AudioService.shared
    private var dadJoke: DadJoke?
    private var dadJokeImage: UIImage?
    private var colorTimer: Timer?

    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpControls()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.spinMeBottomConstraint.constant = 0
        self.view.backgroundColor = UIColor(red: 9 / 255, green: 143 / 255, blue: 118 / 255, alpha: 0.62)
        appService.getRandomJoke(completionHandler: { (dadJoke) in
            self.dadJoke = dadJoke
            self.appService.getJokeImage(joke: dadJoke, completionHandler: { (jokeImage) in
                self.dadJokeImage = jokeImage
            })
        })
    }
}

// MARK: - FortuneWheelViewDelegate
extension StartViewController: FortuneWheelViewDelegate {

    func fortuneWheelDidStart() {
        audioService.playSound(filename: "wheelOfFortune")
        self.colorTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(switchColor), userInfo: nil, repeats: true)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
            self.spinMeBottomConstraint.constant = -1000
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func fortuneWheelDidStop() {
        self.colorTimer?.invalidate()
        self.colorTimer = nil
        if let dadJoke = self.dadJoke, let jokeImage = self.dadJokeImage, let jokeVC = self.storyboard?.instantiateViewController(withIdentifier: "JokeViewController") as? JokeViewController {
            jokeVC.joke = dadJoke
            jokeVC.jokeImage = jokeImage
            self.navigationController?.pushViewController(jokeVC, animated: true)
        }
    }
}

// MARK: - Private methods
extension StartViewController {

    private func setUpControls() {
        self.fortuneWheelView.delegate = self
    }

    @objc private func switchColor() {
        self.multiColorView.backgroundColor = ColorService.shared.getRandomColor()
    }
}
