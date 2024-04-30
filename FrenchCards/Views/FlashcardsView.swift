//
//  FlashcardsView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 30/04/2024.
//

import SwiftUI

struct FlashcardsView: View {
    @State private var isSheetPresented = false
    @State private var flashcards: [Flashcard] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(flashcards) { flashcard in
                        FlashcardRow(flashcard: flashcard)
                    }
                    .onDelete(perform: deleteFlashcard)
                }
                .listStyle(PlainListStyle())
                .foregroundColor(.blue)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isSheetPresented.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isSheetPresented) {
                    CreateFlashcardView(flashcards: $flashcards)
                }
                .padding(.horizontal)
                .navigationTitle("Word Database")
            }
            .onAppear {
                if let savedFlashcards = UserDefaults.standard.data(forKey: "flashcards") {
                    if let decodedFlashcards = try? JSONDecoder().decode([Flashcard].self, from: savedFlashcards) {
                        self.flashcards = decodedFlashcards
                    }
                }
            }
        }
    }
    
    func deleteFlashcard(at offsets: IndexSet) {
        flashcards.remove(atOffsets: offsets)
        saveFlashcards()
    }
    
    func saveFlashcards() {
        if let encoded = try? JSONEncoder().encode(flashcards) {
            UserDefaults.standard.set(encoded, forKey: "flashcards")
        }
    }
}

struct FlashcardRow: View {
    let flashcard: Flashcard
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(flashcard.frenchWord)
                .font(.headline)
            Text(flashcard.englishTranslation)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    FlashcardsView()
}
