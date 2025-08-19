import AVFoundation

class AudioInput : Equatable, Hashable
{
    let id : UUID = UUID()
    let name : String
    let port : AVAudioSessionPortDescription?
    
    init(name: String, port: AVAudioSessionPortDescription?)
    {
        self.name = name
        self.port = port
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    static func == (lhs: AudioInput, rhs: AudioInput) -> Bool
    {
        return lhs.id == rhs.id
    }
}
