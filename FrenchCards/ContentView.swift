import SwiftUI

struct ContentView: View {
    @State private var flashcards: [Flashcard] = []
    
    var body: some View {
        TabView {
            LearnView()
                .tabItem {
                    Image(systemName: "lanyardcard")
                    Text("Exercise")
                }
            
            DiscoverView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("Discover")
                }
            
            FlashcardsView()
                .tabItem {
                    Image(systemName: "list.triangle")
                    Text("Words")
                }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
