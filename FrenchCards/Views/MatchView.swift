//
//  MatchView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 02/05/2024.
//

import SwiftUI

struct WordPair: Identifiable {
    let id = UUID()
    let english: String
    let french: String
}

struct MatchView: View {
    @State private var wordPairs: [WordPair] = []
    @State private var shuffledIndices: [Int] = []
    @State private var shuffledFrenchIndices: [Int] = []
    @State private var selectedPair: WordPair?
    
    private func loadRandomPairs() {
        guard let url = Bundle.main.url(forResource: "translated_words", withExtension: "txt") else {
            print("Error: translated_words.txt not found")
            return
        }
        
        do {
            let contents = try String(contentsOf: url)
            var pairs: [WordPair] = []
            let lines = contents.components(separatedBy: .newlines).shuffled() // Shuffle lines
            for line in lines {
                let components = line.components(separatedBy: " ")
                guard components.count >= 2 else {
                    print("Error: Invalid format in line: \(line)")
                    continue
                }
                let frenchWord = components[0]
                let englishWord = components[1..<components.count].joined(separator: " ")
                pairs.append(WordPair(english: englishWord, french: frenchWord))
                if pairs.count >= 5 {
                    break
                }
            }
            
            wordPairs = pairs.shuffled()

            shuffledIndices = (0..<wordPairs.count).shuffled()
            
            shuffledFrenchIndices = shuffledIndices.shuffled()
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            return
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ForEach(0..<min(wordPairs.count, shuffledIndices.count), id: \.self) { index in
                    HStack(spacing: 20) {
                        Button(action: {
                            selectedPair = wordPairs[index]
                            print(wordPairs[index].french)
                        }) {
                            Text(wordPairs[index].english)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .frame(width: UIScreen.main.bounds.width / 3)
                        
                        Spacer()
                        
                        Button(action: {
                            selectedPair = wordPairs[index]
                            print(wordPairs[index].english)
                        }) {
                            Text(wordPairs[shuffledFrenchIndices[index]].french)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .frame(width: UIScreen.main.bounds.width / 3)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Match Words")
            .onAppear {
                loadRandomPairs()
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
