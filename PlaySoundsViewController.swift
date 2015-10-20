//
//  PlaySoundsViewController.swift
//  my pitch perfect
//
//  Created by Kathleen Stukenborg on 9/29/15.
//  Copyright © 2015 Kathleen Stukenborg. All rights reserved.
//

import UIKit
import AVFoundation
//  One object of this class allows you to playback your audio in a variety of ways. 

class PlaySoundsViewController: UIViewController,AVAudioPlayerDelegate {
    var receivedAudio:RecordedAudio! //parameter passed in through segue
    var audioFile:AVAudioFile! // variable for pathname of the received audio
    var audioEngine:AVAudioEngine! //runs/connects/attaches objects for audio
    var audioSession:AVAudioSession!  //sets up an audio session
    var echoNode:AVAudioUnitDelay!
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    var audioPlayerEcho:AVAudioPlayer = AVAudioPlayer()
    var audioPlayerNode:AVAudioPlayerNode = AVAudioPlayerNode()
    var changeThePitch:AVAudioUnitTimePitch!
    
    @IBOutlet weak var snailOutlet: UIButton!

    
    /* This function calls the playSpeed function with the parameter of 0.5 so that it will play slowly. */
    @IBAction func snailAction(sender: UIButton)  {
        playSpeed(0.5)
    }
   
    /* This function is called before the view is loaded.  It sets up the audio player and audio session for the view. */
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.hidden = true
        audioPlayer = AVAudioPlayer()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine = AVAudioEngine()
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioFile =  AVAudioFile(forReading: receivedAudio.filePathUrl)
        }
        catch {
            print("couldn't set up the audio file")
        }
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioPlayer.delegate   = self
    }
    
    /* When an audio file finishes playing, this function
    is called and hides the stop button for slow and fast
    buttons */
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stopButton.hidden = true
        }
    }
    
    /* This function is called by Darth Vader and the
    Chipmonk functions  with the value of the pitch.  This function will set the pitch and then call other
        functions to play the sound. */
    func playAudioWithVariablePitch(pitch: Float){
        stopAndResetAudio()
        changeThePitch = AVAudioUnitTimePitch()
        if changeThePitch  == nil {
            print("changeThePitch is nil")
        } else{
            changeThePitch.pitch = pitch
            attachAndConnectNodes(changeThePitch)
        }
    }
    
    // This function calls another function so the audio will be played at a pitch of -1000.
    @IBAction func darthVaderAction(sender: UIButton) {
        showStopButton()
        playAudioWithVariablePitch(-1000)
    }
    // This function calls another function so the audio will be played at a pitch of 1000.
    @IBAction func chipmonkAction(sender: UIButton) {
        showStopButton()
        playAudioWithVariablePitch(1000)
    }
    
    // This function sets up the audio to played with an reverb.
    @IBAction func reverbAction(sender: AnyObject) {
        stopAndResetAudio()
        let audioUnitReverb = AVAudioUnitReverb()
        audioUnitReverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        audioUnitReverb.wetDryMix = 50.0
        attachAndConnectNodes(audioUnitReverb)
          }
    
    /* This function schedules when the sound should be played.  It starts the audioEngine and audioSession and then sets the audioPlayerNode to play. */
    func playTheSounds() {
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        audioPlayerNode.play()

    }
    // this function stops and resets the audioPlayer, audioPlayerNode and audioEngine
    func stopAndResetAudio () {
        showStopButton()
        audioPlayer.stop()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()

    }
    
    /* This function attaches and connects the audio node that is sent in as a parameter to an AVEngine and then calls the funcion to play the sound. */
    func attachAndConnectNodes(node: AVAudioNode) {
        audioEngine = AVAudioEngine()
        audioEngine.attachNode(node as AVAudioNode)
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.connect(audioPlayerNode , to: node, format: nil)
        audioEngine.connect(node, to: audioEngine.outputNode, format: nil)
        playTheSounds()
    }
    
    // This function sets up the audio to played with an echo.
    @IBAction func echoAction(sender: AnyObject) {
        stopAndResetAudio()
        echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.3)
        attachAndConnectNodes(echoNode)
    }
    
    // This function plays the sound at whatever rate is passed in as the parameter.
    func playSpeed( rate: Float){
        stopAndResetAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    /* This function calls the playSpeed function with the parameter of 2.0 so that it will play quickly. */
    @IBAction func fastAction(sender: UIButton) {
        playSpeed(2.0)
    }
    
    /* When you press the stop buttion, it will stop the audioPlayer and/or the audioPlayerNode so that the sounds will stop playing. */
    @IBAction func stop(sender: AnyObject) {
        /*audioPlayer.stop()
        try! audioPlayerNode.stop()
        stopButton.hidden = true*/
        stopAndResetAudio()

    }
    
    // This function just displays the stopButton.
    func showStopButton() {
        stopButton.hidden = false
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
