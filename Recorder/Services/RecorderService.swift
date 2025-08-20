import Combine
import Collections
import AVFoundation

extension RecorderView
{
    class RecorderService : NSObject, AVAudioRecorderDelegate
    {
        private(set) var inputs : CurrentValueSubject<[AudioInput], Never> = .init([])

        private var audioRecorder: AVAudioRecorder?
        private var session: AVAudioSession
        
        override init()
        {
            self.session = AVAudioSession.sharedInstance()
            super.init()
            loadAudioDevices()
        }
        
        func loadAudioDevices()
        {
            var availableDevices : [AudioInput] = []
            
//            AVAudioApplication.requestRecordPermission() { granted in
//                print("Permission granted: \(granted)")
//            }

            do
            {
                try session.setCategory(.playAndRecord,
                                        mode: .default,
                                        options: [.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker])
                try session.setActive(true)
            } catch {
                print("Failed to configure and activate session: \(error.localizedDescription)")
            }

            for input in session.availableInputs ?? []
            {
                availableDevices.append(AudioInput(name: input.portName,
                                                   port: input))
            }
            
            self.inputs.send(availableDevices)
        }
        
        func startRecord()
        {
            let newRecordURL = createTemporaryURL()
            let settings = recordingSettings()
            
            do
            {
                self.audioRecorder = try AVAudioRecorder(url: newRecordURL, settings: settings)
                self.audioRecorder?.record()
            }
            catch {}
        }
 
        func pauseRecord()
        {
            self.audioRecorder?.pause()
        }
      
        func unpauseRecord()
        {
            self.audioRecorder?.record()
        }
        
        func stopRecord()
        {
            self.audioRecorder?.stop()
        }
        
        func setPreferredInput(input: AudioInput)
        {
            try? self.session.setPreferredInput(input.port)
        }
        
        private func createTemporaryURL() -> URL
        {
            let appFilesUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: "Recordings")
            
            try? FileManager.default.createDirectory(at: appFilesUrl,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
            
            return appFilesUrl.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
        }
        
        private func recordingSettings() -> [String : Any]
        {
            [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
             AVSampleRateKey: 44100.0,
             AVNumberOfChannelsKey: 2,
             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        }
    }
}

