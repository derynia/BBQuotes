//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 10/02/2025.
//

import SwiftUI

struct QuoteView: View {
    let quote: String
    let image: URL
    let character: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Text("\"\(quote)\"")
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .padding()
            .background(.black.opacity(0.5))
            .clipShape(.rect(cornerRadius: 25))
            .padding(.horizontal)
        ZStack(alignment: .bottom) {
            AsyncImage(url: image) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: width, height: height)
            
            Text(character)
                .foregroundStyle(.white)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            
        }
        .frame(width: width, height: height)
        .clipShape(.rect(cornerRadius: 50))
    }
}

#Preview {
    QuoteView(
        quote: "Some quote",
        image: URL(string: "https://cdn.glitch.com/3c3ffadc-3406-4440-bb95-d40ec8fcde72%2FNelsonMuntz.png?1497567511185")!,
        character: "Some character",
        width: 300,
        height: 500
    )
}
