//
//  ViewController.swift
//  PitchPerfect
//
//  Created by IT on 9/20/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    lazy var recordingLabel: UILabel = {
        let label = UILabel()
        self.view.addSubview(label)
        return label
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var stopRecordingButton: UIButton = {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        return button
    }()
    
   
    lazy var audioRecorder: AVAudioRecorder = {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        let recorder = try! AVAudioRecorder(url: filePath!, settings: [:])
        recorder.delegate = self
        recorder.isMeteringEnabled = true
        return recorder
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Pitch Perfect"
        recordingLabel.text = "Tap to Record"
        recordButton.setImage(#imageLiteral(resourceName: "recordButton"), for: .normal)
        stopRecordingButton.setImage(#imageLiteral(resourceName: "stopRecordingButton"), for: .normal)
        recordButton.addTarget(self, action: #selector(startRecording(sender:)), for: .touchUpInside)
        stopRecordingButton.addTarget(self, action: #selector(stopRecording(sender:)), for: .touchUpInside)
        
        let viewArray =  [recordButton, recordingLabel, stopRecordingButton] as [UIView]
        
        let stackView = UIStackView(arrangedSubviews: viewArray)
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let viewsDict = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[stackView]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-120-[stackView]-120-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict)
        
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)

        
        
        
        
    }
    
    func startRecording(sender:UIButton) {
        recordingLabel.text = "Recording in progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        audioRecorder.record()
        
    }
    
    func stopRecording(sender: UIButton) {
        recordingLabel.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let psVC = PlaySoundsViewController()
            psVC.recordedAudioURL = audioRecorder.url 
            self.navigationController?.pushViewController(psVC, animated: true)
        } else {
            print("Recording failed.")
        }
    }
    
    
}

