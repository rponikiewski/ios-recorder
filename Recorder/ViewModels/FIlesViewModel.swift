import UIKit
import Combine

extension FilesView
{
    class ViewModel : ObservableObject
    {
        @Published var files : [AudioFile] = []
        @Published var isPlaying : Bool = false
        @Published var playheadValue : Float = 0
        @Published var isDragging : Bool = false
        
        private let filesService : FilesService = FilesService()
        private let playerService : PlayerService = PlayerService()

        private var cancellables : Set<AnyCancellable> = []
        
        init()
        {
            self.filesService.files
                .assign(to: &$files)
            
            self.playerService.currentTime
                .assign(to: &$playheadValue)
            
            self.$isDragging.sink { [weak self] isDragging in
                guard let self, self.isPlaying else { return }
                
                if isDragging
                {
                    self.playerService.pause()
                }
                else
                {
                    self.playerService.play()
                }
            }
            .store(in: &cancellables)
        }
        
        func updateFile(file : AudioFile)
        {
            playerService.updateFile(file: file.url)
            playerService.movePlayer(to: 0)
            isPlaying = false
        }
        
        func updateFileName(name : String, file : AudioFile)
        {
            filesService.updateFileName(name: name, file: file)
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
        
        func movePlayhead(to : Float64)
        {
            playerService.movePlayer(to: to)
        }
    }
}
