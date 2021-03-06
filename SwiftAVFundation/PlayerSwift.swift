import Foundation
import AVFoundation
import UIKit

protocol sharedInstanceDelegate {
  func sharedInstanceChanged(newVal: Bool)
}

protocol errorMessageDelegate {
  func errorMessageChanged(newVal: String)
}
class RadioPlayer : NSObject {
  
  static let sharedInstance = RadioPlayer()
  var instanceDelegate:sharedInstanceDelegate? = nil
  var sharedInstanceBool = false {
    didSet {
      if let delegate = self.instanceDelegate {
        delegate.sharedInstanceChanged(newVal: self.sharedInstanceBool)
      }
    }
  }
  
  private var player = AVPlayer(url: NSURL(string: "http://yinyueshiting.baidu.com/data2/music/241630560/123985044129600128.mp3?xcode=3f1acb1cd8666ce9c85f964b2abbb8a2")! as URL)
  private var playerItem: AVPlayerItem?
  private var isPlaying = false
  
  var errorDelegate:errorMessageDelegate? = nil
  var errorMessage = "" {
    didSet {
      if let delegate = self.errorDelegate {
        delegate.errorMessageChanged(newVal: self.errorMessage)
      }
    }
  }
  
  override init() {
    super.init()
    
    errorMessage = ""
    
    let asset: AVURLAsset = AVURLAsset(url: NSURL(string: "http://yinyueshiting.baidu.com/data2/music/241630560/123985044129600128.mp3?xcode=3f1acb1cd8666ce9c85f964b2abbb8a2")! as URL, options: nil)
    
    let statusKey = "tracks"
    
    asset.loadValuesAsynchronously(forKeys: [statusKey], completionHandler: {
      
      var error: NSError? = nil
      
      DispatchQueue.main.async(execute: {
        let status: AVKeyValueStatus = asset.statusOfValue(forKey: statusKey, error: &error)
        
        if status == AVKeyValueStatus.loaded{
          
          let playerItem = AVPlayerItem(asset: asset)
          
          self.player = AVPlayer(playerItem: playerItem)
          self.sharedInstanceBool = true
          
        } else {
          self.errorMessage = error!.localizedDescription
          print(error!)
        }
        
      })
      
    })
    
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
      object: nil,
      queue: nil,
      using: { notification in
        print("Status: Failed to continue")
        self.errorMessage = "Stream was interrupted"
    })
    
    print("Initializing new player")
    
  }
  
  func resetPlayer() {
    errorMessage = ""
    
    let asset: AVURLAsset = AVURLAsset(url: NSURL(string: "http://yinyueshiting.baidu.com/data2/music/241630560/123985044129600128.mp3?xcode=3f1acb1cd8666ce9c85f964b2abbb8a2")! as URL, options: nil)
    
    let statusKey = "tracks"
    
    asset.loadValuesAsynchronously(forKeys: [statusKey], completionHandler: {
      var error: NSError? = nil
      
      DispatchQueue.main.async(execute: {
        let status: AVKeyValueStatus = asset.statusOfValue(forKey: statusKey, error: &error)
        
        if status == AVKeyValueStatus.loaded{
          
          let playerItem = AVPlayerItem(asset: asset)
          //playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: &ItemStatusContext)
          
          self.player = AVPlayer(playerItem: playerItem)
          self.sharedInstanceBool = true
          
        } else {
          self.errorMessage = error!.localizedDescription
          print(error!)
        }
        
      })
    })
  }
  
  func bufferFull() -> Bool {
    return bufferAvailableSeconds() > 45.0
  }
  
  func bufferAvailableSeconds() -> TimeInterval {
    // Check if there is a player instance
    if ((player.currentItem) != nil) {
      
      // Get current AVPlayerItem
      let item: AVPlayerItem = player.currentItem!
      if (item.status == AVPlayerItemStatus.readyToPlay) {
        
        let timeRangeArray: NSArray = item.loadedTimeRanges as NSArray
        if timeRangeArray.count < 1 { return(CMTimeGetSeconds(kCMTimeInvalid)) }
        let aTimeRange: CMTimeRange = (timeRangeArray.object(at: 0) as AnyObject).timeRangeValue
        //let startTime = CMTimeGetSeconds(aTimeRange.end)
        let loadedDuration = CMTimeGetSeconds(aTimeRange.duration)
        return (TimeInterval)(loadedDuration)
      }
      else {
        return(CMTimeGetSeconds(kCMTimeInvalid))
      }
    }
    else {
      return(CMTimeGetSeconds(kCMTimeInvalid))
    }
  }
  
  func play() {
    player.play()
    isPlaying = true
    print("Radio is \(isPlaying ? "" : "not ")playing")
  }
  
  func pause() {
    player.pause()
    isPlaying = false
    print("Radio is \(isPlaying ? "" : "not ")playing")
  }
  
  func currentlyPlaying() -> Bool {
    return isPlaying
  }
  
}
