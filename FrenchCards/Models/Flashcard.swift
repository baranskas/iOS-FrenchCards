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
    static let flashcardsKey = "SavedFlashcards"
    
    static func loadFlashcards() -> [Flashcard] {
        if let savedFlashcardsData = UserDefaults.standard.data(forKey: flashcardsKey),
           let savedFlashcards = try? JSONDecoder().decode([Flashcard].self, from: savedFlashcardsData) {
            return savedFlashcards
        }
        
        guard let fileURL = Bundle.main.url(forResource: "wordlist", withExtension: "csv") else {
            fatalError("Could not find wordlist.csv in the bundle")
        }
        
        do {
            let data = try String(contentsOf: fileURL)
            let lines = data.components(separatedBy: .newlines)
            var flashcards = [Flashcard]()
            
            for line in lines.dropFirst() {
                let columns = line.components(separatedBy: ",")
                if columns.count >= 6 {
                    let flashcard = Flashcard(frenchWord: columns[1], englishTranslation: columns[2])
                    flashcards.append(flashcard)
                }
            }

            let flashcardsData = try JSONEncoder().encode(flashcards)
            UserDefaults.standard.set(flashcardsData, forKey: flashcardsKey)
            
            return flashcards
        } catch {
            fatalError("Failed to load contents of wordlist.csv: \(error)")
        }
    }
}
