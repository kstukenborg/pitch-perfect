//
//  RecordSoundsViewController.swift
//  my pitch perfect
//
//  Created by Kathleen Stukenborg on 9/28/15.
//  Copyright © 2015 Kathleen Stukenborg. All rights reserved.
//

import UIKit
import AVFoundation

/* One object of this class allows the user to record his/her voice.
The user also can pause the recording and then continue recording.*/

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var firstTimeRecord:Bool!
    
    @IBOutlet weak var recordOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.text = "Tap Microphone to Record"
        recordingLabel.hidden = false
        stopOutlet.hidden = true
        pauseOutlet.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTimeRecord = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /* This function allows the user to either record or continue recording their voice. */
    @IBAction func record(sender: UIButton) {
        if firstTimeRecord == true {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            // when we become audioRecorder's delegate, we can run all of the functions of audioRecorder
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        audioRecorder.record()
        recordingLabel.text = "Recording"
        recordingLabel.hidden = false
        stopOutlet.hidden = false
        pauseOutlet.hidden = false
        recordOutlet.enabled = false
    }
    
    /*  This function allows the user to pause the recording. */
    @IBAction func pauseButton(sender: AnyObject) {
        audioRecorder.pause()
        stopOutlet.hidden = true
        recordingLabel.text = "Press microphone to continue recording"
        recordingLabel.hidden = false
        firstTimeRecord = false
        recordOutlet.enabled = true
    }
    
    @IBOutlet weak var pauseOutlet: UIButton!
    
    /*  This function is called when the audio is finished recording.  It puts the information for the recording into recordedAudio.  */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // save audio
        if flag {
            recordedAudio = RecordedAudio(filePathUrl:recorder.url,title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordingLabel.text = "Recording was not successful, try again."
            recordingLabel.hidden = false
        }
    }
    
    /* This function sets the playSounds view controller to be the destination controller and sets data
    as our user's recorded audio to be passed to the next screen. */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio //get the data that was passed in.
            playSoundsVC.receivedAudio  = data
        }
    }
    /* This function stops the recording.  */
    @IBAction func stopAction(sender: UIButton) {
        recordingLabel.text = "Press to Record"
        recordingLabel.hidden = false
        stopOutlet.hidden = true
        recordOutlet.enabled = true
        audioRecorder.stop()
    }
}

