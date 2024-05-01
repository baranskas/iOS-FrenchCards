//
//  LearnView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 30/04/2024.
//

import SwiftUI

struct LearnView: View {
    @State private var translationVisible: Bool = false
    @State private var flashcards: [Flashcard] = []
    @State private var isSheetPresented = false

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 13) {
                    ForEach(flashcards.indices, id: \.self) { index in
                        FlashcardView(flashcard: flashcards[index], translationVisible: self.translationVisible)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .zIndex(Double(abs(flashcards.count/2 - index)))
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical)
            }
            .navigationTitle("Exercise")
            .onTapGesture {
                self.toggleTranslation()
            }
            .onAppear {
                if let savedFlashcards = UserDefaults.standard.data(forKey: "flashcards") {
                    if let decodedFlashcards = try? JSONDecoder().decode([Flashcard].self, from: savedFlashcards) {
                        self.flashcards = decodedFlashcards
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSheetPresented.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                SettingsView()
            }
        }
    }

    private func toggleTranslation() {
        translationVisible.toggle()
    }
}



struct FlashcardView: View {
    let flashcard: Flashcard
    @State private var translationVisible: Bool = false
    
    init(flashcard: Flashcard, translationVisible: Bool) {
        self.flashcard = flashcard
        self._translationVisible = State(initialValue: translationVisible)
    }
    
    var body: some View {
        ZStack {
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
                .padding(.bottom, 150)
                
                Text(translationVisible ? flashcard.englishTranslation : flashcard.frenchWord)
                    .font(.title)
                    .foregroundColor(translationVisible ? .black : .white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 16)
                    .scaleEffect(x: translationVisible ? -1 : 1, y: 1) // Flip the text horizontally
            }
            .frame(width: 180, height: 200)
            .background(translationVisible ? Color.white : Color.indigo) // Background color of the card
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
        }
    }
}


struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        return LearnView()
    }
}
