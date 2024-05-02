//
//  SettingsView.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 01/05/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    
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
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .bold()
                        Spacer()
                    }
                    .background(colorScheme == .dark ? .white : .black)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 30)
                    .navigationTitle("Settings")
                }
                Button(action: {
                    toggleDarkMode()
                }) {
                    HStack {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .padding()
                        Text(isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode")
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .bold()
                        Spacer()
                    }
                    .background(colorScheme == .dark ? .white : .black)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                Spacer()
            }
            .background(colorScheme == .dark ? .black : .white)
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
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode") // Save user's preference
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
        
        print("Switched to \(isDarkMode ? "Dark" : "Light") Mode")
    }
}

#Preview {
    SettingsView()
}
