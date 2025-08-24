import Combine
import Collections
import AVFoundation
import SoundFramework

extension RecorderView
{
    class ViewModel : NSObject, ObservableObject
    {
        @Published var timerText : String = "00:00:00"
        @Published var recordingState : RecorderState = .idle
        @Published var inputs : [AudioInput] = []
        @Published var selectedDevice : AudioInput?

        private var recorder : IOSRecorder
        private var cancellables : Set<AnyCancellable> = []
        
        override init()
        {
            self.recorder = IOSRecorder()
            
            super.init()
            
            subscribe()
        }
        
        private func subscribe()
        {
            recorder.state
                .assign(to: &$recordingState)
            
            recorder.inputs
                .sink { [weak self] newInputs in
                    guard let self else { return }
                    
                    self.inputs = newInputs
                    
                    self.selectedDevice = self.inputs.first(where: {$0 == self.selectedDevice}) ?? self.inputs.first
                }
                .store(in: &cancellables)
            
            recorder.timer
                .sink { [weak self] timeInterval in
                    guard let self else { return }
                    
                    self.timerText = self.formatTime(timeInterval: timeInterval)
                }
                .store(in: &cancellables)
        }
        
        func startRecord()
        {
            let _ = recorder.startRecording()
        }
 
        func pauseRecord()
        {
            let _ = recorder.pauseRecording()
        }
      
        func unpauseRecord()
        {
            let _ = recorder.resumeRecording()
        }
        
        func stopRecord()
        {
            let _ = recorder.stopRecording()
        }
        
        func setInput(input: AudioInput)
        {
            recorder.setPreferedInput(input)
        }
        
        private func formatTime(timeInterval : TimeInterval) -> String
        {
            let totalMs = Int(timeInterval * 1000)
            let minutes = totalMs / 60000
            let seconds = (totalMs % 60000) / 1000
            let centiseconds = (totalMs % 1000) / 10
            
            return String(format: "%02d:%02d:%02d", minutes, seconds, centiseconds)
        }
    }
}
