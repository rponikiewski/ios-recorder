import Combine

protocol IRecorder
{
    var state : AnyPublisher<RecorderState, Never> { get }

    func prepareToRecord(to url : URL,
                         settings recorderSettings : RecorderSettings) -> Bool
    func startRecording() -> Bool
    func pauseRecording() -> Bool
    func resumeRecording() -> Bool
    func stopRecording() -> Bool
}
