import UIKit
import Combine

extension FilesView
{
    class ViewModel : ObservableObject
    {
        @Published var files : [AudioFile] = []
        
        private let filesService : FilesService = FilesService()

        
        init()
        {
            self.filesService.files.assign(to: &$files)
        }
        
    }
}
