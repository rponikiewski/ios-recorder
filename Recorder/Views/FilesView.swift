import SwiftUI

struct FilesView : View
{
    @StateObject var viewModel : ViewModel
    
    init()
    {
        self._viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View
    {
        GeometryReader
        { geometry in
            VStack(alignment: .leading)
            {
                Text("Files")
                    .foregroundColor(.black)
                    .font(.title)
                    .padding(10)
                    .bold()
                
                ScrollView(.vertical)
                {
                    VStack(alignment: .leading)
                    {
                        ForEach(viewModel.files, id: \.id)
                        { file in
                            FileView(name: file.displayName)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    viewModel.updateFile(file: file)
                                }
                        }
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height - 150)

                HStack
                {
                    Slider(value: $viewModel.playheadValue,
                           in: 0...1)
                        .padding(10)
                    
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .padding(15)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            if viewModel.isPlaying
                            {
                                viewModel.pause()
                            }
                            else
                            {
                                viewModel.play()
                            }
                        }
                }
            }
        }
    }
}

#Preview
{
    FilesView()
}

