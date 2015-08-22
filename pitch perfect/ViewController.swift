//
//  ViewController.swift
//  pitch perfect
//
//  Created by ZhouLiwei on 8/8/15.
//  Copyright (c) 2015 ZhouLiwei. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopbutton: UIButton!
    @IBOutlet weak var recordbutton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        //basically this is the place you want to hide/show,enable/disable things
        //instead of setup these properties here, you can also setup them in the attribute tag of the button
        //as what we do for the shown/hidden properties of the label and the stop button
        //however, it seems the setting in the attribute only works for the first time
        //but this function here works everytime when this view is loaded again
        recordbutton.enabled = true
        stopbutton.hidden = true
        recordingInProgress.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordaudio(sender: UIButton) {
        //IB stands for "interface button"
        //TODO: actually record the users voice
        recordingInProgress.hidden = false
        stopbutton.hidden = false
        recordbutton.enabled = false
        println("recording in progress")
        //get the directory within the app
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //The following is too memory consuming
        //let currentDateTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss"
        //let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
        //The following overwrite the previous record so that saving memory
        let recordingName = "myaudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //initialize audio recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //TODO: save the record audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            //TODO: move to the second scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("recording was not successful")
            recordbutton.enabled = true
            stopbutton.hidden = true
            recordingInProgress.hidden = true
        }
    }
    
    //this func is just called before any segure is performed so it is a good place to send data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            
            //define the dest viewcontroller
            let playSoundsVC:playSoundViewController = segue.destinationViewController as playSoundViewController
            
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        //recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

