import UIKit
import Combine

extension FilesView
{
    class ViewModel : ObservableObject
    {
        @Published var files : [AudioFile] = []
        @Published var isPlaying : Bool = false
        @Published var playheadValue : Float = 0
        
        private let filesService : FilesService = FilesService()
        private let playerService : PlayerService = PlayerService()

        private var cancellables : Set<AnyCancellable> = []
        
        init()
        {
            self.filesService.files.assign(to: &$files)
            
            self.playerService.currentTime.assign(to: &$playheadValue)
        }
        
        func updateFile(file : AudioFile)
        {
            playerService.updateFile(file: file.url)
            playerService.movePlayer(to: 0)
            isPlaying = false
        }
        
        func play()
        {
            playerService.play()
            isPlaying = true
        }
        
        func pause()
        {
            playerService.pause()
            isPlaying = false
        }
    }
}
