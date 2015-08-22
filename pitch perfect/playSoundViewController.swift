//
//  playSoundViewController.swift
//  pitch perfect
//
//  Created by ZhouLiwei on 8/8/15.
//  Copyright (c) 2015 ZhouLiwei. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundViewController: UIViewController {

    //it's important that DON'T declare a player as a local variable in a button action function or no sounds will play.
    //This reason is: just as the player.play() makes the player start playing, I reach the end of the action function.
    //As a result, all its local variables go out of scope and cease to exist. (get released)
    //So microseconds after the player starts to play, it gets wiped out of existence.
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(animated: Bool) {
//        var fileurl: NSURL!
//        
//        if var slow_audio_path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            fileurl = NSURL.fileURLWithPath(slow_audio_path)
//            
//        }else{
//            println("The file is not found")
//        }

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func resetAudio(rate: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        //play audio slooooowly here
        //audioPlayer.currentTime = 0.0
        //audioPlayer.rate = 0.5
        resetAudio(0.5)
        audioPlayer.play()

        
    }
    @IBAction func playaudiofast(sender: UIButton) {
        //audioPlayer.currentTime = 0.0
        //audioPlayer.rate = 1.5
        resetAudio(1.5)
        audioPlayer.play()
    }
    
    @IBAction func stopplaying(sender: UIButton) {
        resetAudio(1.0)
    }

    func changePitch(pitch: Float){
        resetAudio(1.0)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()

        
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        changePitch(1000)
        
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        changePitch(-1000)
    }
}
