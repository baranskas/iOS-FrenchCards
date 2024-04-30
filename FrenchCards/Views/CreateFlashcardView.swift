//
//  CreateFlashcardView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 30/04/2024.
//
import SwiftUI

struct CreateFlashcardView: View {
    @Binding var flashcards: [Flashcard]
    
    @State private var frenchWord = ""
    @State private var englishTranslation = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            Text("Create French Card")
                .font(.title)
                .bold()
                .padding(.vertical, 20)
            
            TextField("French Word", text: $frenchWord)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)

            
            TextField("English Translation", text: $englishTranslation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
            
            Button(action: {
                let flashcard = Flashcard(frenchWord: frenchWord, englishTranslation: englishTranslation)
                flashcards.append(flashcard)
                saveFlashcards()
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create")
                    .padding(.horizontal, 50)
                    .padding(.vertical)
                    .foregroundColor(.white)
                    .background(Color.indigo)
                    .cornerRadius(20)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Create Flashcard")
    }
    
    func saveFlashcards() {
        if let encoded = try? JSONEncoder().encode(flashcards) {
            UserDefaults.standard.set(encoded, forKey: "flashcards")
        }
    }
}


struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(flashcards: .constant([]))
    }
}
