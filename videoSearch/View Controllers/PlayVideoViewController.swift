//
//  PlayVideoViewController.swift
//  videoSearch
//
//  Created by Arihant Arora on 7/17/18.
//  Copyright © 2018 Arihant Arora. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: UIViewController, YTPlayerViewDelegate {
    //Youtube Player
    
    var videoPlayer: YTPlayerView?
    var myView = YTPlayerView()
    
    let sc = VideoSearchViewController()
    var selectedID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoPlayer = myView
        self.videoPlayer?.delegate = self
        
        let params = ["autoplay": 1, "playsinline": 1]
        videoPlayer?.delegate = self

        setMyViews()
        
        videoPlayer?.load(withVideoId: selectedID, playerVars:params)
        
        //playerView.delegate = self
        //let selectedVideoID = sc.vidID
        
        //self.videoPlayer.load(withVideoId: sc.vidID)
        //self.videoPlayer?.playVideo()
        
        
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView)
    {
//        let sc = VideoSearchViewController()
//        videoPlayer?.cuePlaylist(byVideos: sc.videosArray, index: 0, startSeconds: 0, suggestedQuality: YTPlaybackQuality.default)
        self.videoPlayer?.playVideo()
    }
    
    func setMyViews(){
        self.view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        myView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        myView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 600).isActive = true
    }
        
        //setupUI()
       // playerView.load(withVideoId: selectedVideoID)
        // Do any additional setup after loading the view.
        //self.videoPlayer.delegate = self
//        videoPlayer = YTPlayerView.init(frame: self.view.frame)
//        self.videoPlayer.delegate = self
//        self.view.addSubview(videoPlayer)
//        videoPlayer.load(withVideoId: YouTubeVideoID)
//        print(YouTubeVideoID)
    
//
//    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        playerView.playVideo()
//    }
//    @objc func dismissButtonPressed() {
//       self.dismiss(animated: true, completion: nil)
//    }
}
