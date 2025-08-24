import SwiftUI

struct PlayerProgress : View
{
    @State var innerProgress : CGFloat
    
    @Binding var progress : Float
    @Binding var isDragging : Bool

    private let onChanged : (CGFloat) -> Void
    
    init(_ progress: Binding<Float>,
         isDragging : Binding<Bool>,
         onChanged : @escaping (CGFloat) -> Void)
    {
        self._progress = progress
        self._isDragging = isDragging
        self.onChanged = onChanged
        self.innerProgress = 0.0
    }
    
    var body: some View
    {
        GeometryReader
        { geometry in
            ZStack(alignment: .leading)
            {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.Rp.secondary)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isDragging = true
                                let newProgress = CGFloat(gesture.location.x / geometry.size.width)
                                
                                innerProgress = newProgress >= 1.0 ? 1.0 : newProgress <= 0.0 ? 0.0 : newProgress
                                onChanged(innerProgress)
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.Rp.primary)
                    .frame(width: (isDragging ? innerProgress : CGFloat(progress)) * geometry.size.width)
                    .allowsHitTesting(false)
                    .animation(.linear, value: progress)
                    .animation(.linear, value: innerProgress)
            }
        }
    }
}


#Preview
{
    struct PreviewWrapper : View
    {
        @State var progress : Float = 0.2
        @State var isDragging : Bool = false
        
        var body: some View
        {
            PlayerProgress($progress,
                           isDragging: $isDragging,
                           onChanged: { newProgress in progress = Float(newProgress) })
        }
    }
    return PreviewWrapper()
        .frame(width: 300, height: 10)
}
