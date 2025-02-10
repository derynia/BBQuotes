//
//  EpisodeView.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 08/02/2025.
//

import SwiftUI

struct CharacterShortView: View {
    let character: Char
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(character.name)
                .font(.largeTitle)
            
            TabView {
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
            .clipShape(.rect(cornerRadius: 25))
            
            Text("Portrayed by: \(character.portrayedBy)")
            
        }
        .padding()
        .foregroundStyle(.white)
        .background(.black.opacity(0.6))
        .clipShape(.rect(cornerRadius: 25))
        .padding(.horizontal)
    }
}

#Preview {
    CharacterShortView(character: ViewModel().randomCharacter)
}
