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
    @State private var draggingOffset: CGFloat = 0
    @State private var dragging: Bool = false

    @State private var flashcards: [Flashcard] = []

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(flashcards.indices, id: \.self) { index in
                        FlashcardView(flashcard: flashcards[index], translationVisible: self.translationVisible && index == self.currentIndex)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        self.dragging = true
                                        self.draggingOffset = value.translation.width
                                    }
                                    .onEnded { value in
                                        self.dragging = false
                                        let threshold: CGFloat = 100
                                        if value.predictedEndTranslation.width < -threshold && self.currentIndex < self.flashcards.count - 1 {
                                            self.moveToNextCard()
                                        } else if value.predictedEndTranslation.width > threshold && self.currentIndex > 0 {
                                            self.moveToPreviousCard()
                                        } else {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                self.moveToNearestCard()
                                            }
                                        }
                                    }
                            )
                            .zIndex(Double(abs(flashcards.count/2 - index)))
                    }
                }
                .padding()
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

    private func moveToNearestCard() {
        let cardWidth: CGFloat = UIScreen.main.bounds.width / 2 - 24
        let spacing: CGFloat = 16
        let nearestIndex = Int((draggingOffset + CGFloat(currentIndex) * (cardWidth + spacing) + cardWidth / 2) / (cardWidth + spacing))
        currentIndex = max(0, min(nearestIndex, flashcards.count - 1))
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
