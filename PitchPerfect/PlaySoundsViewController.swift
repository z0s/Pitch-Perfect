//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by IT on 9/20/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    lazy var snailButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = ButtonType.slow.rawValue
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 75).isActive = true
        return button
    }()
    
    lazy var chipmunkButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = ButtonType.chipmunk.rawValue
        button.leadingAnchor.constraint(equalTo: self.snailButton.trailingAnchor, constant: 75).isActive = true
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        return button
    }()

    lazy var vaderButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.tag = ButtonType.vader.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 75).isActive = true
        button.topAnchor.constraint(equalTo: self.snailButton.bottomAnchor, constant: 50).isActive = true
        return button
    }()
    lazy var rabbitButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = ButtonType.fast.rawValue
        button.leadingAnchor.constraint(equalTo: self.vaderButton.trailingAnchor, constant: 75).isActive = true
        button.topAnchor.constraint(equalTo: self.chipmunkButton.bottomAnchor, constant: 50).isActive = true

        return button
    }()
    lazy var echoButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = ButtonType.echo.rawValue
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 75).isActive = true
        button.topAnchor.constraint(equalTo: self.vaderButton.bottomAnchor, constant: 50).isActive = true
 
        return button
    }()
    lazy var reverbButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = ButtonType.reverb.rawValue
        button.leadingAnchor.constraint(equalTo: self.echoButton.trailingAnchor, constant: 75).isActive = true

        button.topAnchor.constraint(equalTo: self.rabbitButton.bottomAnchor, constant: 50).isActive = true
    
        return button
    }()
    lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: self.reverbButton.bottomAnchor, constant: 50).isActive = true

        return button
    }()
    
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode : AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb }
    
    func playSoundForButton(sender: UIButton) {
        print("Play Sound button pressed")
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
            
        }
        
        configureUI(.playing)
    }
    
    func stopButtonPressed(){
        print("Stop Audio Button Pressed")
       stopAudio()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PlaySoundsViewController loaded")
        setupAudio()
        
        snailButton.setImage(#imageLiteral(resourceName: "snailButton"), for: .normal)
        snailButton.addTarget(self, action: #selector(playSoundForButton(sender:)), for: .touchUpInside)
        
        chipmunkButton.setImage(#imageLiteral(resourceName: "chipmunkButton"), for: .normal)
        chipmunkButton.addTarget(self, action: #selector(playSoundForButton(sender:)), for: .touchUpInside)
        
        vaderButton.setImage(#imageLiteral(resourceName: "darthVaderButton"), for: .normal)
        vaderButton.addTarget(self, action: #selector(playSoundForButton(sender:)), for: .touchUpInside)
        
        rabbitButton.setImage(#imageLiteral(resourceName: "rabbitButton"), for: .normal)
        rabbitButton.addTarget(self, action: #selector(playSoundForButton(sender:)), for: .touchUpInside)
        
        echoButton.setImage(#imageLiteral(resourceName: "echoButton"), for: .normal)
        echoButton.addTarget(self, action: #selector(playSoundForButton(sender:)), for: .touchUpInside)
        
        reverbButton.setImage(#imageLiteral(resourceName: "reverbButton"), for: .normal)
        reverbButton.addTarget(self, action: #selector(playSoundForButton(sender:)), for: .touchUpInside)
        

        stopButton.setImage(#imageLiteral(resourceName: "stopRecordingButton"), for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
       configureUI(.notPlaying)
    }
    
}
extension PlaySoundsViewController: AVAudioPlayerDelegate {
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    // raw values correspond to sender tags
    enum PlayingState { case playing, notPlaying }
    
    
    // MARK: Audio Functions
    
    func setupAudio() {
        // initialize (recording) audio file
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(describing: error))
        }
        print("Audio has been setup")
    }
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        }
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(PlaySoundsViewController.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    
    // MARK: Connect List of Audio Nodes
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    func stopAudio() {
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        configureUI(.notPlaying)
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    
    // MARK: UI Functions
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        snailButton.isEnabled = enabled
        chipmunkButton.isEnabled = enabled
        rabbitButton.isEnabled = enabled
        vaderButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }
    
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


