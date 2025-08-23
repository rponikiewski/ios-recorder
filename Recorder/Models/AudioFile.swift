import UIKit

class AudioFile : Equatable, Hashable, Identifiable
{
    let id : UUID
    private(set) var url : URL
    private(set) var displayName : String
    
    init(url: URL)
    {
        self.id = UUID()
        self.url = url
        self.displayName = String(url.lastPathComponent.split(separator: ".").first!)
    }
    
    static func == (lhs: AudioFile, rhs: AudioFile) -> Bool
    {
        return lhs.url == rhs.url
    }
    
    func updateFile(newUrl : URL)
    {
        url = newUrl
        displayName = String(url.lastPathComponent.split(separator: ".").first!)
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}
