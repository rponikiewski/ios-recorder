import SwiftUI
import SoundFramework

struct RecorderView : View
{
    @StateObject var viewModel : ViewModel
    
    init()
    {
        self._viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text("Devices")
                .font(.title)
                .padding(10)
                .bold()
                .foregroundColor(.black)

            ScrollView(.horizontal)
            {
                HStack(spacing: 0)
                {
                    ForEach(self.viewModel.inputs, id: \.self)
                    { input in
                        DeviceView(name: input.name,
                                   isSelected: input == viewModel.selectedDevice)
                        .frame(height: 50)
                        .padding(5)
                        .onTapGesture {
                            self.viewModel.setInput(input: input)
                        }
                    }
                }
            }
            Spacer()
            VStack(alignment: .center)
            {
                Text(self.viewModel.timerText)
                    .foregroundColor(.black)
                HStack
                {
                    CustomButton(text: self.viewModel.recordingState != .idle ? "Stop" : "Start",
                                 style: .primary)
                    {
                        if self.viewModel.recordingState != .idle
                        {
                            self.viewModel.stopRecord()
                        }
                        else
                        {
                            self.viewModel.startRecord()
                        }
                    }
                    .frame(width: self.viewModel.recordingState != .idle ? 100 : 200, height: 50)
                    .animation(.easeInOut, value: self.viewModel.recordingState)
                    .padding(.top, 20)

                    if self.viewModel.recordingState != .idle
                    {
                        CustomButton(text: self.viewModel.recordingState == .paused ? "Record" : "Pause", style: .secondary)
                        {
                                if self.viewModel.recordingState == .paused
                                {
                                    self.viewModel.unpauseRecord()
                                }
                                else
                                {
                                    self.viewModel.pauseRecord()
                                }
                            }
                        .frame(width: self.viewModel.recordingState != .idle ? 100 : 0, height: 50)
                        .animation(.easeInOut, value: self.viewModel.recordingState)
                        .padding(.top, 20)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview
{
    RecorderView()
}
