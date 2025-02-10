//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 04/01/2025.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String
    @State var showCharacterInfo: Int = -1
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpaces())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successSimpsonsQuote:
                            QuoteView(
                                quote: vm.simpsonsQuote.quote,
                                image: vm.simpsonsQuote.image,
                                character: vm.simpsonsQuote.character,
                                width: geo.size.width/1.1,
                                height: geo.size.height / 1.8
                            )
                        case .successCharacter:
                            CharacterShortView(character: vm.randomCharacter)
                                .onTapGesture {
                                    showCharacterInfo = showCharacterInfo == 2 ? -1 : 2
                                }
                        case .successQuote:
                            QuoteView(
                                quote: vm.quote.quote,
                                image: vm.character.images[0],
                                character: vm.character.name,
                                width: geo.size.width/1.1,
                                height: geo.size.height / 1.8
                            )
                            .onTapGesture {
                                showCharacterInfo = showCharacterInfo == 1 ? -1 : 1
                            }
                            
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                        case .error(let error):
                            Text(error.localizedDescription)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    HStack {
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                        } label: {
                            Text("Get\rrandom\rquote")
                            .font(.body)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.removeSpaces())Button"))
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(
                                color: Color("\(show.removeSpaces())Shadow"),
                                radius: 2
                            )
                        }
                        Spacer()
                        Button {
                            Task {
                                await vm.getCharacterData(for: show)
                            }
                        } label: {
                            Text("Get\rrandom\rcharacter")
                            .font(.body)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.removeSpaces())Button"))
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(
                                color: Color("\(show.removeSpaces())Shadow"),
                                radius: 2
                            )
                        }

                        Spacer()
                        Button {
                            Task {
                                await vm.getEpisodeData(for: show)
                            }
                        } label: {
                            Text("Get\rrandom\repisode")
                            .font(.body)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.removeSpaces())Button"))
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(
                                color: Color("\(show.removeSpaces())Shadow"),
                                radius: 2
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    Spacer(minLength: 95)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .toolbarBackgroundVisibility(Visibility.visible, for: .tabBar)
        .sheet(isPresented: Binding<Bool>(
            get: { showCharacterInfo > -1 },
            set: { if !$0 { showCharacterInfo = -1 } }
        )) {
            CharacterView(
                character: showCharacterInfo == 1 ? vm.character : vm.randomCharacter,
                show: show
            )
        }
        .onAppear {
            if (vm.status == .notStarted) {
                Task { await vm.getQuoteData(for: show) }
            }
        }
    }
}

#Preview {
    FetchView(show: Constants.bcsName)
        .preferredColorScheme(.dark)
}
