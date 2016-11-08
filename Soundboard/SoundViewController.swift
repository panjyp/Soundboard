//
//  SoundViewController.swift
//  Soundboard
//
//  Created by Jeff Pan on 11/7/16.
//  Copyright © 2016 Jeff Pan. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    func setupRecorder() {
        do {
            
            //Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Create URL for the audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //Create settings for the audio recorder
            
            var mySetting: [String:Any] = [:]
            mySetting[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            mySetting[AVSampleRateKey] = 44100.0
            mySetting[AVNumberOfChannelsKey] = 2
            
            //Create Audiorecorder object
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: mySetting)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            //Stop recording
            audioRecorder?.stop()
            //Change button title to Record
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
        }
        
        
        
    }
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {
            
        }
        
    }
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        
        sound.name = textField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
