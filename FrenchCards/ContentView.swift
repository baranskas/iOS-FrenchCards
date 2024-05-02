import SwiftUI

struct ContentView: View {
    @State private var flashcards: [Flashcard] = []
    @AppStorage("isDarkMode") private var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    
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
            
            MatchView()
                .tabItem {
                    Image(systemName: "menucard")
                    Text("Match")
                }
            
            FlashcardsView()
                .tabItem {
                    Image(systemName: "list.triangle")
                    Text("Words")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // Apply preferred color scheme
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
