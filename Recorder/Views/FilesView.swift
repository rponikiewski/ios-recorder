import SwiftUI

struct FilesView : View
{
    @StateObject var viewModel : ViewModel
    @State private var showSheet = false
    @State private var selectedSheet : AudioFile?

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
                Text("Recordings")
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
                                .onLongPressGesture {
                                    selectedSheet = file
                                    showSheet.toggle()
                                }
                        }
                        .sheet(item: $selectedSheet) {
                            FileNameSheet(text: $0.displayName)
                            { name in
                                viewModel.updateFileName(name: name,
                                                         file: selectedSheet!)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height - 150)

                VStack(spacing: 0)
                {
                    HStack(spacing: 0)
                    {
                        Text(viewModel.files.first!.displayName)
                            .padding(15)
                        Spacer()
                        
                        Image(systemName: "chevron.left.chevron.left.dotted")
                            .resizable()
                            .padding(15)
                            .frame(width: 45, height: 45)
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
                        Image(systemName: "chevron.right.dotted.chevron.right")
                            .resizable()
                            .padding(15)
                            .frame(width: 45, height: 45)
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
                    
                    PlayerProgress($viewModel.playheadValue,
                                   isDragging: $viewModel.isDragging)
                    { value in
                        viewModel.movePlayhead(to: Float64(value))
                    }
                    .frame(height: 10)
                    
                }
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(10)
            }
        }
    }
}

#Preview
{
    FilesView()
}

