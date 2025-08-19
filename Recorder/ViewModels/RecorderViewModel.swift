import Combine
import Collections
import AVFoundation

extension RecorderView
{
    class ViewModel : NSObject, ObservableObject
    {
        @Published var timerText : String = "00:00:00"
        @Published var recordingState : RecoderState = .idle
        @Published var inputs : [AudioInput] = []
        @Published var selectedDevice : AudioInput?

        private var recorderService : RecorderService
        private var timerService : TimerService
        
        override init()
        {
            self.recorderService = RecorderService()
            self.timerService = TimerService()
            
            super.init()

            self.recorderService.inputs.assign(to: &$inputs)
            self.timerService.timerText.assign(to: &$timerText)
            
            self.selectedDevice = self.inputs.first
        }
        
        func startRecord()
        {
            recorderService.startRecord()
            timerService.startTimer()
            recordingState = .recording
        }
 
        func pauseRecord()
        {
            recorderService.pauseRecord()
            timerService.pauseTimer()
            recordingState = .paused
        }
      
        func unpauseRecord()
        {
            recorderService.unpauseRecord()
            timerService.resumeTimer()
            recordingState = .recording
        }
        
        func stopRecord()
        {
            recorderService.stopRecord()
            timerService.resetTimer()
            recordingState = .idle
        }
        
        func setInput(input: AudioInput)
        {
            recorderService.setPreferredInput(input: input)
            selectedDevice = input
        }
    }
}
