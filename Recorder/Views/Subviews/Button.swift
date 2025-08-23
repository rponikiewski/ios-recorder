import SwiftUI

struct CustomButton : View
{
    enum Style
    {
        case primary
        case secondary
    }
    
    
    let text : String
    let style : Style
    let action : (() -> Void)
    
    private var backgroundColor : Color
    {
        style == .primary ? .Rp.primary : .Rp.secondary
    }
    
    private var textColor : Color
    {
        style == .primary ? .Rp.primaryText : .Rp.secondaryText
    }
    
    init(text : String, style : Style = .primary, action : @escaping () -> Void)
    {
        self.text = text
        self.style = style
        self.action = action
    }
    
    var body: some View
    {
        GeometryReader
        { geometry in
            ZStack
            {
                ZStack()
                {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(backgroundColor)

                    Text(text)
                        .padding(10)
                        .foregroundColor(textColor)
                }
            }
            .onTapGesture(perform: self.action)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}


#Preview {
    
    VStack
    {
        CustomButton(text: "Primary", style: .primary)
        {
            
        }
        .frame(width: 200, height: 50)
        
        CustomButton(text: "Secondary", style: .secondary)
        {
            
        }
        .frame(width: 200, height: 50)
    }
    
}
