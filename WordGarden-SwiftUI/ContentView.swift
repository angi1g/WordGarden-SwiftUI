//
//  ContentView.swift
//  WordGarden-SwiftUI
//
//  Created by Giacomo on 23/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var currentWord = 0
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var gameStatusMssage = "Quanti tentativi rimasti per scoprire la parola nascosta?"
    @State private var wordsToGuess = [
        "MARIA",
        "ANNA",
        "BABBO",
        "MAMMA"
    ]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Parole trovate: \(wordsGuessed)")
                    Text("Parole perse: \(wordsMissed)")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Parole rimanenti: \(wordsToGuess.count - wordsGuessed - wordsMissed)")
                    Text("Parole totali: \(wordsToGuess.count)")
                }
            }.padding(.horizontal)
            
            Spacer()
            
            Text(gameStatusMssage)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            //MARK: Switch to wordsToGuess[currentWord]
            Text("_ _ _ _ _")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            if playAgainHidden {
                HStack {
                    TextField("", text: $guessedLetter)
                        //.textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .border(Color.gray, width: 2) // da cancellare
                    //.overlay {
                    //  RoundedRectangle(cornerRadius: 5)
                    //      .stroke(.gray, lineWidth: 2)
                    //}
                    
                    Button("Scegli una lettera") {
                        //MARK: Guess a letter button action here
                        playAgainHidden = false
                    }
                    //.buttonStyle(.bordered)
                    //.tint(.mint)
                }
            } else {
                Button("Un'altra parola?") {
                    //MARK: Another word button action here
                    playAgainHidden = true
                }
                .padding()
                //.buttonStyle(.borderedProminent)
                //.tint(.mint)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
