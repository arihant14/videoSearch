//
//  VideoSearchViewController.swift
//  videoSearch
//
//  Created by Arihant Arora on 7/16/18.
//  Copyright © 2018 Arihant Arora. All rights reserved.
//

import UIKit
import GoogleSignIn


class VideoSearchViewController: UIViewController,UISearchBarDelegate, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, GIDSignInUIDelegate {
    var vidID: String = ""
    var videosArray = [Video]()
    var selectedCell = CollectionViewCell()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        if GIDSignIn.sharedInstance().currentUser == nil{
            print("Signed out")}
        self.performSegue(withIdentifier: "goToLogin", sender: ViewController.self)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
        navigationItem.title = "Video Search"
        self.navigationController?.navigationBar.tintColor = UIColor.blue

        self.hideKeyboard()
        
        searchBar.delegate = self
        loadVideos(searchString: "")
    }
    
    func checkLogin() {
        if GIDSignIn.sharedInstance().currentUser == nil{
        self.performSegue(withIdentifier: "goToLogin", sender: ViewController.self)}
    }
    
    func presentLoginController() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            
            return print("Could not instantiate view controller with identifier of type SecondViewController")
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //var apiKey = "AIzaSyCwY0nSNmz0qYXDx15PV0jH3RTVn4KGli0"
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let string = searchBar.text {
            //print(string)
            searchBar.endEditing(true)
            loadVideos(searchString: string)
        }
        
    }
    
    func formatString(string: String) -> String {
        let newString = string.replacingOccurrences(of: " ", with: "+")
        return newString
    }
    
    //MARK: Parsing data
    func loadVideos(searchString: String) {
        let querryString = formatString(string: searchString)
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(querryString)&type=video&key=AIzaSyCwY0nSNmz0qYXDx15PV0jH3RTVn4KGli0"
        //print(urlString)
        let url = URL(string: urlString)
        
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let err = error {
                print("Unable to Reqst from Url : \(err)")
            }
            guard let dataa = data else {return}
            do {
                
                if let jsonData = try JSONSerialization.jsonObject(with: dataa, options: []) as? [String:Any]{
                    
                    guard let items = jsonData["items"] as? [[String:Any]] else {return}
                    //print(items)
                    self.videosArray = []
                    for item in items {
                        
                        guard let id = item["id"] as? [String:Any] else{return}
                        guard let videoId = id["videoId"] as? String else {return}
                        guard let snippet = item["snippet"] as? [String:Any] else{return}
                        guard let title = snippet["title"] as? String else {return}
                        guard let thumbnails = snippet["thumbnails"] as? [String:Any] else{return}
                        guard let mediumThumbnail = thumbnails["medium"] as? [String:Any] else{return}
                        guard let mediumThumbnailImage = mediumThumbnail["url"] as? String else {return}
                        let video = Video(videoID: videoId, thumbnailImage: mediumThumbnailImage, title: title)
                        self.videosArray.append(video)
                    }
                    //print(self.videosArray)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            
            }.resume()
        
    }
    
    //MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! CollectionViewCell
        cell.video = videosArray[indexPath.item]
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout giving constraints to cells height and width
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width  , height: 250)//view.frame.width - 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "videoPlayController") as? PlayVideoViewController else {

            return print("Could not instantiate view controller with identifier of type PlayVideoViewController")
        }
        selectedCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        vidID = videosArray[indexPath.item].videoID
        let pv = PlayVideoViewController()
        pv.selectedID = vidID
        
        
        //CHANGE THIS TO SHOW BACK BUTTON IN PLAYER WINDOW
        self.navigationController?.pushViewController(pv, animated: true)
        

        
        //print(vidID)
        
        //self.performSegue(withIdentifier: "toDetail", sender: self)
    }

        //vc.transitioningDelegate = self
        //self.navigationController?.present(vc, animated: true, completion: nil)
       // .video = videosArray[indexPath.item]


    
    // giving line spacing between the cells in collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetail"{
//            let destinationViewController = segue.destination as! PlayVideoViewController
//            destinationViewController.YouTubeVideoID = savedVideoID
//        }
//}
}
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    //MARK: Transition
