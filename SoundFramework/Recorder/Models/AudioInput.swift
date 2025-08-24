import AVFoundation

public class AudioInput : Equatable, Hashable
{
    public let id : UUID = UUID()
    public let name : String
    public let port : AVAudioSessionPortDescription?
    
    init(name: String, port: AVAudioSessionPortDescription?)
    {
        self.name = name
        self.port = port
    }
    
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    public static func == (lhs: AudioInput, rhs: AudioInput) -> Bool
    {
        return lhs.id == rhs.id
    }
    
    public static func == (lhs: AudioInput, rhs: AVAudioSessionPortDescription) -> Bool
    {
        return lhs.port == rhs
    }
}
