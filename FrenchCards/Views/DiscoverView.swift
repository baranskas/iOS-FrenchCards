//
//  DiscoverView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 30/04/2024.
//

import SwiftUI

struct DiscoverView: View {
    let flashcards: [Flashcard]
    
    init() {
        if let savedFlashcardsData = UserDefaults.standard.data(forKey: FlashcardLoader.flashcardsKey),
           let savedFlashcards = try? JSONDecoder().decode([Flashcard].self, from: savedFlashcardsData) {
            self.flashcards = savedFlashcards
        } else {
            self.flashcards = FlashcardLoader.loadFlashcards()
        }
    }
    
    var body: some View {
        FlashcardDiscoveryView(flashcards: flashcards)
    }
}
struct FlashcardDiscoveryView: View {
    let flashcards: [Flashcard]
    @State private var currentIndex = 0
    @State private var translationVisible: Bool = false
    
    init(flashcards: [Flashcard]) {
        self.flashcards = flashcards.shuffled()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if flashcards.isEmpty {
                    Text("No flashcards available")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    HStack {
                        Button(action: {
                            self.currentIndex = (self.currentIndex + self.flashcards.count - 1) % self.flashcards.count
                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.title)
                                .padding()
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        ZStack {
                            HStack {
                                if !translationVisible {
                                    Text("🇫🇷")
                                        .font(.title)
                                        .padding(.leading, 15)
                                }
                                Spacer()
                                if translationVisible {
                                    Text("🇺🇸")
                                        .font(.title)
                                        .padding(.leading, 15)
                                        .scaleEffect(x: -1)
                                }
                            }
                            .padding(.bottom, 240)
                            
                            Text(translationVisible ? flashcards[currentIndex].englishTranslation : flashcards[currentIndex].frenchWord)
                                .font(.system(size: 30))
                                .foregroundColor(translationVisible ? .black : .white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.horizontal, 16)
                                .scaleEffect(x: translationVisible ? -1 : 1, y: 1)
                        }
                        .frame(width: 230, height: 300)
                        .background(translationVisible ? Color.white : Color.indigo)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .rotation3DEffect(
                            .degrees(translationVisible ? 180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.translationVisible.toggle()
                            }
                        }
                        Button(action: {
                            self.currentIndex = (self.currentIndex + 1) % self.flashcards.count
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .padding()
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    Text("\(self.currentIndex + 1) / \(self.flashcards.count)")
                        .font(.title3)
                        .bold()
                        .padding(.vertical)
                }
            }
            .navigationTitle("Discover Words")
        }
    }
}


#Preview {
    DiscoverView()
}

