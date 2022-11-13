//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Osmar Juarez on 05/11/22.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var sliderDuration: UISlider!
    @IBOutlet var sliderVolume: UISlider!
    @IBOutlet var imgViewGIF: UIImageView!
    
    var audioPlayer = AVAudioPlayer()
    var timer: Timer? //to execute a code setting by a time interval
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadAudio()
    }
    
    private func loadGIF(){
        if let gifURL =  Bundle.main.url(forResource: "song", withExtension: ".gif") {
            imgViewGIF.image =  UIImage.animatedImage(withAnimatedGIFURL: gifURL)
        }
    }
    
    private func loadAudio() {
        guard let myAudioUrl =  Bundle.main.url(forResource: "MUSIC3", withExtension: "mp3")
        else {
            print("An ERROR occur when the bundle try to find the audio")
            return
        }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: myAudioUrl)
            initInterface()
        }catch {
            print("An ERROR occur trying to load the audio, \(error.localizedDescription)")
        }
    }
    
    private func initInterface() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSliderDuration), userInfo: nil, repeats: true)
        sliderDuration.value = 0
        sliderDuration.maximumValue = Float(audioPlayer.duration)
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        audioPlayer.delegate = self
        audioPlayer.volume = 0.5
        sliderVolume.value = 0.5
        imgViewGIF.image = UIImage(named: "song.gif")
    }
    
    @objc func updateSliderDuration() {
        sliderDuration.value =  Float(audioPlayer.currentTime)
    }

    @IBAction func btnPlayTouch(_ sender: Any) {
        audioPlayer.play()
        loadGIF()
        btnStop.isEnabled = true
        btnPlay.isEnabled = false
    }
    
    @IBAction func btnStopTouch(_ sender: Any) {
        audioPlayer.stop()
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        imgViewGIF.image = UIImage(named: "song.gif")
    }
    
    @IBAction func sliderDurationChange(_ sender: UISlider) {
        audioPlayer.volume = sliderVolume.value
    }
    
    @IBAction func sliderVolumeChange(_ sender: UISlider) {
        audioPlayer.currentTime = Double(sliderDuration.value)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        initInterface()
    }
}

