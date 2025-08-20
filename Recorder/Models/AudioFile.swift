import UIKit

class AudioFile : Equatable, Hashable
{
    let id : UUID
    let url : URL
    let displayName : String
    
    init(url: URL, displayName: String)
    {
        self.id = UUID()
        self.url = url
        self.displayName = displayName
    }
    
    static func == (lhs: AudioFile, rhs: AudioFile) -> Bool
    {
        return lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}
