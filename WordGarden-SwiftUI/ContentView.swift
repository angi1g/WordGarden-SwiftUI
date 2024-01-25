//
//  ContentView.swift
//  WordGarden-SwiftUI
//
//  Created by Giacomo on 23/01/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessedLetter = ""
    @State private var guessesRemaining = 8
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Un'altra parola?"
    @State private var gameStatusMessage = "Quanti tentativi per scoprire la parola nascosta?"
    @State private var audioPlayer: AVAudioPlayer!
    //@FocusState private var textFieldIsFocused: Bool
    private let maximumGuesses = 8
    @State private var wordsToGuess = [
        "MARIA",
        "ANNA",
        "BABBO",
        "MAMMA",
        "NONNA",
        "NONNO",
        "GATTO",
        "CANE",
        "FROZEN",
        "FIORE",
        "ALBERO",
        "MELA",
        "PERA",
        "PIPPO",
        "PLUTO",
        "PAPPA",
        "TOPO"
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
            
            Text(gameStatusMessage)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .padding()
            
            Spacer()
            
            //MARK: Switch to wordsToGuess[currentWord]
            Text(revealedWord)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            if playAgainHidden {
                HStack {
                    let charSet = CharacterSet.letters
                    TextField("", text: $guessedLetter)
                        //.textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .frame(width: 30)
                        .border(Color.gray, width: 2) // da cancellare
                        .keyboardType(.asciiCapable)
                        //.submitLabel(.done)
                        .disableAutocorrection(true)
                        .autocapitalization(.allCharacters)
                        .onChange(of: guessedLetter, perform: { _ in
                            guessedLetter = guessedLetter.trimmingCharacters(in: charSet.inverted)
                            guard let lastChar = guessedLetter.last
                            else {
                                return
                            }
                            guessedLetter = String(lastChar)
                            guessedLetter = guessedLetter.uppercased()
                        })
                        //.onSubmit() {
                        // guard guessedLetter = "" else {
                        //  return
                        // }
                        // guessALetter()
                        // updateGamePlay()
                        //}
                        //.focused($textFieldIsFocused)
                    //.overlay {
                    //  RoundedRectangle(cornerRadius: 5)
                    //      .stroke(.gray, lineWidth: 2)
                    //}
                    
                    Button("Scegli una lettera") {
                        guessALetter()
                        updateGamePlay()
                    }
                    .disabled(guessedLetter.isEmpty)
                    //.buttonStyle(.bordered)
                    //.tint(.mint)
                }
            } else {
                Button(playAgainButtonLabel) {
                    // Se tutte le parole sono state indovinate
                    if currentWordIndex == wordsToGuess.count {
                        wordsToGuess.shuffle()
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Un'altra parola?"
                    }
                    // Reset per la parola successiva
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
                    lettersGuessed = ""
                    guessesRemaining = maximumGuesses
                    imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "Quanti tentativi per scoprire la parola nascosta?"
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
                .animation(.easeIn(duration: 0.75))
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear() {
            wordsToGuess.shuffle()
            wordToGuess = wordsToGuess[currentWordIndex]
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
            guessesRemaining = maximumGuesses
        }
    }
    func guessALetter() {
        //textFieldIsFocused = false
        lettersGuessed += guessedLetter
        revealedWord = ""
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord += "\(letter) "
            } else {
            revealedWord += "_ "
            }
        }
        revealedWord.removeLast()
        
    }
    func updateGamePlay() {
        if !wordToGuess.contains(guessedLetter) {
            guessesRemaining -= 1
            imageName = "wilt\(guessesRemaining)"
            playSound(soundName: "incorrect")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                imageName = "flower\(guessesRemaining)"
            }
        } else {
            playSound(soundName: "correct")
        }
        // quando passiamo alla parola successiva?
        if !revealedWord.contains("_") {
            gameStatusMessage = "Giusto! Hai indovinato in \(lettersGuessed.count) tentativi!"
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-guessed")
        } else if guessesRemaining == 0 {
            gameStatusMessage = "Mi dispiace! Hai finito i tentativi!"
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-not-guessed")
        } else {
            gameStatusMessage = "Hai fatto \(lettersGuessed.count) tentativ\(lettersGuessed.count == 1 ? "o" : "i")"
        }
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Gioca di nuovo?"
            gameStatusMessage = gameStatusMessage + "\n Hai trovato tutte le parole! Riniziamo da capo?"
        }
        guessedLetter = ""
    }
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("* Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription) creating AudioPlayer.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
