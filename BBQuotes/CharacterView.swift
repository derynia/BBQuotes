//
//  ContentView.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 04/01/2025.
//

import SwiftUI

struct CharacterView: View {
    let vm = CharacterViewModel()
    let character: Char
    let show: String
    @State private var selectedTab: URL
    
    init(character: Char, show: String) {
        self.character = character
        self.show = show
        _selectedTab = State(initialValue: character.images[Int.random(in: 0..<character.images.count)]) // ✅ Initialize here
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.removeCaseAndSpaces())
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView {
                        TabView(selection: $selectedTab) {
                            ForEach(character.images, id: \.self) { characterImageUrl in
                                AsyncImage(url: characterImageUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(width: geo.size.width/1.2, height: geo.size.height / 1.7)
                        .clipShape(.rect(cornerRadius: 25))
                        .padding(.top, 60)

                        
                        VStack(alignment: .leading) {
                            Text(character.name)
                                .font(.largeTitle)
                            Text("Portrayed by: \(character.portrayedBy)")
                                .font(.subheadline)
                            Divider()
                            
                            Text("\(character.name) Character info")
                                .font(.title2)
                            Text("Born: \(character.birthday)")
                            Divider()
                            Text("Occupations: ")
                            ForEach(character.occupations, id: \.self) { occupation in
                                Text("* \(occupation)")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            Text("Nicknames: ")
                            if character.aliases.count > 0 {
                                ForEach(character.aliases, id: \.self) { alias in
                                    Text("* \(alias)")
                                        .font(.subheadline)
                                }
                            } else {
                                Text("None")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            HStack(alignment: .center) {
                                Text("Random quote:")
                                    .font(.title3)
                                Spacer()
                                Button {
                                    Task {
                                        await vm.getQuoteData(for: character.name)
                                    }
                                } label: {
                                    Image(systemName: "arrow.clockwise") // SF Symbol
                                            .resizable()
                                            .padding(3)
                                            .frame(width: 25, height: 25)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.gray, lineWidth: 1) // Border with rounded corners
                                            )
                                }
                                .frame(width: 30)
                            }
                            .frame(height: 20)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                                
                            switch vm.status {
                            case .notStarted:
                                EmptyView()
                            case .fetching:
                                ProgressView()
                            case .successQuote:
                                Text(vm.quote.quote)
                                    .font(.subheadline)
                            case .error(let error):
                                Text(error.localizedDescription)
                            }
                            
                            Divider()
                            DisclosureGroup("Status (spoiler alert!):") {
                                VStack(alignment: .leading) {
                                    Text(character.status)
                                        .font(.title2)
                                    
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear() {
                                                    withAnimation {
                                                        proxy.scrollTo(1, anchor: .bottom)
                                                    }
                                                }
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        Text("How: \(death.details)")
                                            .padding(.bottom, 7)
                                        
                                        Text("Last words: \"\(death.lastWords)\"")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .tint(.primary)
                            
                        }
                        .frame(width: geo.size.width / 1.25, alignment: .leading)
                        .padding(.bottom, 50)
                        .id(1)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            if (vm.status == .notStarted) {
                Task { await vm.getQuoteData(for: character.name) }
            }
        }
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: Constants.bbName)
}
