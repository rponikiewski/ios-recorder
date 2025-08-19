import Combine
import Collections
import AVFoundation

extension RecorderView
{
    class TimerService
    {
        var timerText : CurrentValueSubject<String, Never> = .init("00:00:00")

        private var timer: Timer?
        private var startTime: Date?
        private var elapsedTimeWhenPaused: TimeInterval = 0
        private var isRunning: Bool = false
        
        func startTimer()
        {
            guard !isRunning else { return }
            
            startTime = Date()
            isRunning = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                self?.updateTimer()
            }
        }
        
        func pauseTimer()
        {
            guard isRunning else { return }
            
            if let startTime = startTime
            {
                elapsedTimeWhenPaused += Date().timeIntervalSince(startTime)
            }
            
            stopTimerExecution()
            isRunning = false
        }
        
        func resumeTimer()
        {
            guard !isRunning else { return }
            
            startTime = Date()
            isRunning = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                self?.updateTimer()
            }
        }
        
        func resetTimer()
        {
            stopTimerExecution()
            elapsedTimeWhenPaused = 0
            startTime = nil
            isRunning = false
            timerText.send(formattedTime(timeInterval: 0))
        }
                
        private func stopTimerExecution() {
            timer?.invalidate()
            timer = nil
        }
        
        private func updateTimer()
        {
            let currentElapsed: TimeInterval
            
            if let startTime = startTime
            {
                currentElapsed = elapsedTimeWhenPaused + Date().timeIntervalSince(startTime)
            }
            else
            {
                currentElapsed = elapsedTimeWhenPaused
            }
            
            timerText.send(formattedTime(timeInterval: currentElapsed))
        }
        
        private func formattedTime(timeInterval : TimeInterval) -> String
        {
            let totalMs = Int(timeInterval * 1000)
            let minutes = totalMs / 60000
            let seconds = (totalMs % 60000) / 1000
            let centiseconds = (totalMs % 1000) / 10  // Setne sekundy (0-99)
            
            return String(format: "%02d:%02d:%02d", minutes, seconds, centiseconds)
        }
        
        deinit
        {
            timer?.invalidate()
        }
    }
}


