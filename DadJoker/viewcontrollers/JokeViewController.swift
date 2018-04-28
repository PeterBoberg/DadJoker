//
// Created by Peter Boberg on 2017-12-11.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SCLAlertView

class JokeViewController: UIViewController {

    // MARK: - Public properties
    var joke: DadJoke?
    var jokeImage: UIImage?

    // MARK: - IBOutlets
    @IBOutlet weak var jokeTextView: UITextView!
    @IBOutlet weak var jokeTextViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var hahaRightConstr: NSLayoutConstraint!
    @IBOutlet weak var hahaLeftConstr: NSLayoutConstraint!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var hahaView: UIImageView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var storeView: UIView!

    // MARK: - Private variables
    private var speechSyntheses = AVSpeechSynthesizer()
    private let dbService = DbService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupControls()
        speak()
    }

    @IBAction func share(_ sender: UIButton) {
        let jokeText = joke?.joke ?? ""
        let activityVC = UIActivityViewController(activityItems: [jokeText], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true)

    }

    @IBAction func store(_ sender: Any) {
        print("Storing item")
        guard let joke = joke else { return }
        self.dbService.save(joke: joke, completion: { (error) in

            guard error == nil else {
                SCLAlertView().showError("Sorry!", subTitle: "Your fantastic joke could not be saved")
                return
            }

            print("Joke successfully saved")
            SCLAlertView().showSuccess("Hooray!", subTitle: "Your joke is saved and you can safely laugh at is about 1000 time more :-)")
            // TODO: Show success message to user
        })
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension JokeViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        UIView.animate(withDuration: 1.0, animations: {
            self.hahaView.alpha = 1
            self.shareView.alpha = 1
            self.storeView.alpha = 1
        })

        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 100, options: [], animations: {
            self.hahaLeftConstr.constant = 0
            self.hahaRightConstr.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)

        AudioService.shared.playRandomLaugh()
    }
}

// MARK: - Private Methods
extension JokeViewController {

    private func setupControls() {
        self.navigationController?.navigationBar.isHidden = false
        self.jokeTextViewBottomConst.constant += 1000
        self.jokeTextView.text = joke?.joke
        self.hahaView.alpha = 0
        self.shareView.alpha = 0
        self.storeView.alpha = 0

        self.hahaLeftConstr.constant = self.view.bounds.width / 2
        self.hahaRightConstr.constant = self.view.bounds.width / 2
    }

    private func speak() {
        guard let jokeText = self.joke?.joke else { return }
        animate(constraint: jokeTextViewBottomConst)
        let voice = AVSpeechSynthesisVoice(language: "en-GB")
        let utterance = AVSpeechUtterance(string: jokeText)
        utterance.voice = voice
        self.speechSyntheses.delegate = self
        self.speechSyntheses.speak(utterance)
    }

    private func animate(constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 300, animations: {
            constraint.constant -= 1000
            self.view.layoutIfNeeded()
        })
    }
}
