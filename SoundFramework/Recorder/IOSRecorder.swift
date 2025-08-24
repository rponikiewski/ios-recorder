import Foundation
import SoundAnalysis
import AVFoundation
import Combine

public class IOSRecorder : IRecorder
{
    private let filesManager : FileManager
    private let audioSession : AudioSession
    
    private var recordingState : CurrentValueSubject<RecorderState, Never> = .init(.idle)
    private var audioInputs : CurrentValueSubject<[AudioInput], Never> = .init([])
    private var currentTimer : CurrentValueSubject<Double, Never> = .init(0)

    private var recorder : AVAudioRecorder?
    private var scheduledTimer : Timer?
    
    public var state : AnyPublisher<RecorderState, Never> {
        recordingState.eraseToAnyPublisher()
    }
    
    public var timer : AnyPublisher<Double, Never> {
        currentTimer.eraseToAnyPublisher()
    }
    
    public let inputs : AnyPublisher<[AudioInput], Never>
    
    public init()
    {
        filesManager = FileManager.default
        audioSession = AudioSession()
        inputs = audioSession.inputs.eraseToAnyPublisher()
    }
    
    public func prepareToRecord(to url : URL,
                                settings recorderSettings : RecorderSettings) -> Bool
    {
        guard reviewNewFileURL(url) else { return false }
        
        do
        {
            recorder = try AVAudioRecorder(url: url,
                                            settings: [:])
        }
        catch let error
        {
            print("Error creating AVAudioRecorder: \(error)")
            return false
        }
        
        guard let recorder = recorder, recorder.prepareToRecord() else { return false }

        recordingState.send(.prepared)
        
        return true
    }
    
    public func startRecording() -> Bool
    {
        guard let unwrappedRecorder = recorder, recordingState.value == .prepared else { return false }

        startTimer()
        
        unwrappedRecorder.record()
        recordingState.send(.recording)
        
        return true
    }
    
    public func pauseRecording() -> Bool
    {
        guard let unwrappedRecorder = recorder, recordingState.value == .recording else { return false }
        unwrappedRecorder.pause()
        
        recordingState.send(.paused)
        return true
    }
    
    public func resumeRecording() -> Bool
    {
        guard let unwrappedRecorder = recorder, recordingState.value == .paused else { return false }
        unwrappedRecorder.record()
        
        recordingState.send(.recording)
        startTimer()
        
        return true
    }
    
    public func stopRecording() -> Bool
    {
        guard let unwrappedRecorder = recorder, recordingState.value != .idle else { return false }

        unwrappedRecorder.stop()
        stopTimer()
        recorder = nil
        recordingState.send(.idle)

        return true
    }
    
    private func reviewNewFileURL(_ url : URL) -> Bool
    {
        let directory = url.deletingLastPathComponent()
        
        if filesManager.fileExists(atPath: directory.path) == false
        {
            do
            {
                try filesManager.createDirectory(at: directory,
                                                 withIntermediateDirectories: true)
            }
            catch let error
            {
                print("Error creating directory \(error.localizedDescription)")
                return false
            }
        }
        
        return true
    }
    
    private func startTimer()
    {
        guard scheduledTimer == nil else { return }
        
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true)
        { [weak self] value in
            guard let self, let recorder = recorder else { return }

            self.currentTimer.send(recorder.currentTime)
        }
    }
    
    private func stopTimer()
    {
        scheduledTimer?.invalidate()
        scheduledTimer = nil
        currentTimer.send(0)
    }
    
    public func setPreferedInput(_ input : AudioInput)
    {
        audioSession.setPreferedInput(input)
    }
}

