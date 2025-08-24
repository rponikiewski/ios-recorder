import AVFoundation
import Combine

public class AudioSession
{
    private static var audioSessionInstance : AVAudioSession?
    private static var timerSessionInstance : Timer?
    private var audioInputs : CurrentValueSubject<[AudioInput], Never>
    private var cancellables = Set<AnyCancellable>()

    public private(set) var inputs : AnyPublisher<[AudioInput], Never>

    public init()
    {
        AudioSession.activate()
        audioInputs = .init([])
        audioInputs.send([])
        inputs = audioInputs.eraseToAnyPublisher()
        
        activateListener()
        updateAvailableInputs()
    }
    
    
    public func setPreferedInput(_ input : AudioInput)
    {
        //TODO: Error handle
        try? AudioSession.audioSessionInstance?.setPreferredInput(input.port)
    }
    
    private static func activate()
    {
        if let _ = AudioSession.audioSessionInstance
        {
            return
        }
        
        let instance = AVAudioSession.sharedInstance()
        
        do
        {
            try instance.setCategory(.playAndRecord,
                                     mode: .default,
                                     options: [.allowAirPlay,
                                               .allowBluetooth,
                                               .allowBluetoothA2DP,
                                               .defaultToSpeaker])
            try instance.setActive(true)
            audioSessionInstance = instance
        }
        catch let error
        {
            print("Error activating audio session: \(error.localizedDescription)")
        }
    }
    
    private func activateListener()
    {
        NotificationCenter.default
            .publisher(for: AVAudioSession.routeChangeNotification, object: AudioSession.audioSessionInstance)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] notification in
                        self?.updateAvailableInputs()
                    }
                    .store(in: &cancellables)
    }
    
    private func updateAvailableInputs()
    {
        var inputs : [AudioInput] = []
        for input in AudioSession.audioSessionInstance?.availableInputs ?? []
        {
            inputs.append(AudioInput(name: input.portName,
                                               port: input))
        }
        audioInputs.send(inputs)
    }
}
