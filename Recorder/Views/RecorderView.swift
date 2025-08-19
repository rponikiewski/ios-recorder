import SwiftUI

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
            Spacer()
            VStack(alignment: .center)
            {
                Text(self.viewModel.timerText)
                    .foregroundColor(.black)
                HStack
                {
                    CustomButton(text: self.viewModel.recordingState != .idle ? "Stop" : "Start",
                                 style: self.viewModel.recordingState != .idle ? .secondary : .primary)
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
                        CustomButton(text: self.viewModel.recordingState == .paused ? "Record" : "Pause")
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
            Text("Devices")
                .font(.title)
                .padding(10)
                .bold()
                .foregroundColor(.black)

            ScrollView(.horizontal)
            {
                HStack
                {
                    ForEach(self.viewModel.inputs, id: \.self)
                    { input in
                        ZStack(alignment: .topLeading)
                        {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black, lineWidth: self.viewModel.selectedDevice == input ? 2 : 0)
                                .fill(Color.init(red: 0.95,
                                                 green: 0.95,
                                                 blue: 0.95))
                                .animation(.easeInOut, value: self.viewModel.selectedDevice)

                            Text(input.name)
                                .bold()
                                .animation(.easeInOut, value: self.viewModel.selectedDevice)
                                .padding(10)
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .frame(width: 100, height: 100)
                        .padding(10)
                        .onTapGesture {
                            self.viewModel.setInput(input: input)
                        }
                    }
                }
            }
        }
        .background(Color.white)
    }
}

#Preview
{
    RecorderView()
}
