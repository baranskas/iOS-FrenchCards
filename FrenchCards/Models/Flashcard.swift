//
//  Flashcard.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 30/04/2024.
//

import Foundation

struct Flashcard: Identifiable, Codable {
    var id = UUID()
    var frenchWord: String
    var englishTranslation: String
}

class FlashcardLoader {
    static let flashcardsKey = "DiscoveryFlashcards"
    
    static func loadFlashcards() -> [Flashcard] {
        if let savedFlashcardsData = UserDefaults.standard.data(forKey: flashcardsKey),
           let savedFlashcards = try? JSONDecoder().decode([Flashcard].self, from: savedFlashcardsData) {
            return savedFlashcards
        }
        
        guard let fileURL = Bundle.main.url(forResource: "translated_words", withExtension: "txt") else {
            fatalError("Could not find translated_words.txt in the bundle")
        }
        
        do {
            let data = try String(contentsOf: fileURL)
            let lines = data.components(separatedBy: .newlines)
            var flashcards = [Flashcard]()
            
            for line in lines {
                let parts = line.components(separatedBy: " ")
                if parts.count >= 2 {
                    let frenchWord = parts[0]
                    let englishTranslation = parts[1...].joined(separator: " ")
                    let flashcard = Flashcard(frenchWord: frenchWord, englishTranslation: englishTranslation)
                    flashcards.append(flashcard)
                }
            }
            
            let flashcardsData = try JSONEncoder().encode(flashcards)
            UserDefaults.standard.set(flashcardsData, forKey: flashcardsKey)
            
            return flashcards
        } catch {
            fatalError("Failed to load contents of translated_words.txt: \(error)")
        }
    }
}
