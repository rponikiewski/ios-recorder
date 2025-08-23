import SwiftUI

struct DeviceView : View
{
    let name : String
    let isSelected : Bool
    
    
    var body: some View
    {
        ZStack(alignment: .topLeading)
        {
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.Rp.secondaryText,
                        lineWidth: isSelected ? 4 : 0)
                .fill(Color.Rp.secondary)
                .animation(.easeInOut, value: isSelected)

            Text(name)
                .bold()
                .animation(.easeInOut, value: isSelected)
                .padding(12)
                .font(.title3)
                .foregroundColor(.Rp.secondaryText)
        }
        .padding(10)
        .cornerRadius(15)
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview
{
    struct PreviewWrapper : View
    {
        @State var progress : Float = 0.2
        @State var isSelected : Bool = false
        
        var body: some View
        {
            DeviceView(name: "Device input name", isSelected: isSelected)
                .onTapGesture {
                    isSelected = !isSelected
                }
        }
    }
    return PreviewWrapper()
        .frame(height: 15)
    
    
}
