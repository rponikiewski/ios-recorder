import UIKit
import Foundation
import Combine

extension FilesView
{
    class FilesService
    {
        private(set) var files : CurrentValueSubject<[AudioFile], Never> = .init([])
        
        init()
        {
            loadFiles()
        }
        
        func loadFiles()
        {
            let recordingsPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: "Recordings")
            
            if let paths = FileManager.default.subpaths(atPath: recordingsPath.path)
            {
                for path in paths
                {
                    let url = recordingsPath.appending(component: path)
                    
                    self.files.value.append(AudioFile(url: url, displayName: url.lastPathComponent))
                }
            }

            self.files.send(self.files.value)
        }
    }
}


