import SwiftUI

struct FileView : View
{
    var name : String
    
    var body: some View
    {
        VStack
        {
            Text(name)
                .lineLimit(nil)
                .font(.title2)
                .bold()
                .padding(14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview
{
    VStack(spacing: 0)
    {
        FileView(name: "File name jdjjf ffjjfjfjfjfjf fjfjjfjfjjf fjfjjfjffjjfjfjfjjf")
            .fixedSize(horizontal: false, vertical: true)
            .padding(10)
    }
}
