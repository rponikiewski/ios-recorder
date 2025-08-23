import SwiftUI

struct FileNameSheet : View
{
    @Environment(\.dismiss) var dismiss

    @State var innerText : String = ""
    private var text : String
    private var onSave : (String) -> Void
    
    init(text: String, onSave: @escaping (String) -> Void)
    {
        self.text = text
        self.onSave = onSave
    }
    
    var body: some View {
        ZStack {
            VStack
            {
                TextField("File name", text: $innerText)
                    .padding(20)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(20)
                
                CustomButton(text: "Save")
                {
                    onSave(innerText)
                    dismiss()
                }
                .frame(width: 100, height: 50)
            }
         }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .onAppear()
        {
            innerText = text
        }
    }
}

