import SwiftUI

struct MainView : View
{
    var body: some View
    {
        TabView
        {
            Tab("Recorder", systemImage: "waveform.circle.fill")
            {
                RecorderView()
            }
            
            Tab("Files", systemImage: "recordingtape.circle")
            {
                FilesView()
            }
        }
        .accentColor(.Rp.primary)
    }
}

#Preview
{
    MainView()
}
