import SwiftUI

struct ContentView: View {
    @State private var flashcards: [Flashcard] = []
    
    var body: some View {
        TabView {
            LearnView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Exercise")
                }
            
            FlashcardsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("French Words")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
