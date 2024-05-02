//
//  SettingsView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 01/05/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    resetDefaults()
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .font(.title)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .padding()
                        Text("Restore Default Storage")
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                    }
                    .background(.black)
                    .cornerRadius(20)
                    .padding()
                    .navigationTitle("Settings")
                }
                Spacer()
            }
        }
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        print("Restored Default Storage")
    }
}

#Preview {
    SettingsView()
}
