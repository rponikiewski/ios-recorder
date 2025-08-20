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
                        }
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height - 200)

            }
        }
    }
}

#Preview
{
    FilesView()
}

