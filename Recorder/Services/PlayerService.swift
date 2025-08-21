import UIKit
import AVFoundation
import Combine

extension FilesView
{
    class PlayerService
    {
        private var player : AVPlayer?
        private var duration : CMTime = .zero
        private var timeObserver : Any?
        private(set) var currentTime : CurrentValueSubject<Float, Never> = .init(.zero)
        
        func updateFile(file : URL)
        {
            if let unwrappedObserver = timeObserver
            {
                player?.removeTimeObserver(unwrappedObserver)
            }
            
            player = AVPlayer(url : file)
            
            if let duration = player?.currentItem?.asset.duration
            {
                self.duration = duration
            }
            
            timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 20),
                                            queue: DispatchQueue.main)
            { [weak self] value in
                
                guard let self else { return }
                
                self.currentTime.send(Float(value.seconds / self.duration.seconds))
            }
        }
        
        func play()
        {
            player?.play()
        }
        
        func pause()
        {
            player?.pause()
        }
        
        func movePlayer(to time : Float64)
        {
            player?.seek(to : CMTimeMultiplyByFloat64(duration, multiplier: time))
            self.currentTime.send(0)
        }
    }
}



