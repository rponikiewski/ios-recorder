import SwiftUI

struct FileView : View
{
    var name : String
    
    var body: some View
    {
        HStack
        {
            Image(systemName: "music.quarternote.3")
                .frame(width: 40, height: 40)
                .background(Color.Rp.secondary)
                .cornerRadius(6)
                .padding(10)
                .accentColor(.Rp.secondaryText)
                
            Text(name)
                .lineLimit(1)
                .truncationMode(.middle)
                .font(.title3)
                .bold()
                .padding(.vertical, 15)
                .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview
{
    VStack(spacing: 0)
    {
        FileView(name: "Name of file")
            .padding(10)
    }
}
