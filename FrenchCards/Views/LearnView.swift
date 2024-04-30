//
//  LearnView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 30/04/2024.
//

import SwiftUI

struct LearnView: View {
    @State private var currentIndex: Int = 0
    @State private var translationVisible: Bool = false

    @State private var flashcards: [Flashcard] = []

    var body: some View {
        NavigationView {
            ZStack {
                ForEach(flashcards.indices, id: \.self) { index in
                    FlashcardView(flashcard: flashcards[index], translationVisible: self.translationVisible && index == self.currentIndex)
                        .offset(x: self.offset(for: index), y: 0)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < -100 && self.currentIndex < self.flashcards.count - 1 {
                                        // Swiped left and not on the last card
                                        withAnimation(.smooth(duration: 0.2)) {
                                            self.moveToNextCard()
                                        }
                                    } else if value.translation.width > 100 && self.currentIndex > 0 {
                                        // Swiped right and not on the first card
                                        withAnimation(.smooth(duration: 0.2)) {
                                            self.moveToPreviousCard()
                                        }
                                    }
                                }
                        )
                        .zIndex(Double(abs(flashcards.count/2 - index)))
                }
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
            .padding(.bottom, 50)
        }
    }

    private func moveToNextCard() {
        currentIndex = (currentIndex + 1) % flashcards.count
        translationVisible = false
    }

    private func moveToPreviousCard() {
        if currentIndex == 0 {
            currentIndex = flashcards.count - 1
        } else {
            currentIndex = (currentIndex - 1) % flashcards.count
        }
        translationVisible = false
    }

    private func toggleTranslation() {
        translationVisible.toggle()
    }

    private func offset(for index: Int) -> CGFloat {
        if flashcards.isEmpty || currentIndex >= flashcards.count {
            return 0
        }

        let cardWidth: CGFloat = 300
        let spacing: CGFloat = 20

        let distance = index - currentIndex

        return CGFloat(distance) * (cardWidth + spacing)
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
            .frame(width: 300, height: 200)
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
