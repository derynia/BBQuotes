//
//  FetchService.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 31/01/2025.
//

import Foundation

struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL: URL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    private let baseSimpsonsURL: URL = URL(string: "https://thesimpsonsquoteapi.glitch.me/")!
    
    func fetchQuote(from show: String) async throws -> Quote {
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [
            URLQueryItem(name: "production", value: show)
        ])
        
        return try await fetchQuoteFromURL(fetchURL: fetchURL)
    }

    func fetchQuote(for character: String) async throws -> Quote {
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [
            URLQueryItem(name: "character", value: character)
        ])
        
        return try await fetchQuoteFromURL(fetchURL: fetchURL)
    }
    
    private func fetchQuoteFromURL(fetchURL: URL) async throws -> Quote {
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        return quote
    }
    
    func fetchSimpsonsQuote() async throws -> SimpsonsQuote? {
        let quoteURL = baseSimpsonsURL.appending(path: "quotes")
        
        let (data, response) = try await URLSession.shared.data(from: quoteURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let quotes = try JSONDecoder().decode([SimpsonsQuote].self, from: data)
                
        if quotes.isEmpty {
            throw FetchError.badResponse
        }
        
        return quotes[0]
    }

    func fetchCharacter(_ name: String) async throws -> Char {
        let quoteURL = baseURL.appending(path: "characters")
        let fetchURL = quoteURL.appending(queryItems: [
            URLQueryItem(name: "name", value: name)
        ])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        	
        let characters = try decoder.decode([Char].self, from: data)
        
        return characters[0]
    }
    
    func fetchRandomCharacter(for show: String) async throws -> Char? {
        let charURL = baseURL.appending(path: "characters/random")
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        while (true) {
            let (data, response) = try await URLSession.shared.data(from: charURL)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw FetchError.badResponse
            }

            let currentChar = try decoder.decode(Char.self, from: data)
            if currentChar.productions.contains(show) {
                return currentChar
            }
        }
    }
    
    func fetchDeath(for character: String) async throws -> Death? {
        let fetchURL = baseURL.appending(path: "deaths")
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let deaths = try decoder.decode([Death].self, from: data)
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        
        return nil
    }
    
    func fetchEpisode(from show: String) async throws -> Episode? {
        let episodeURL = baseURL.appending(path: "episodes")
        let fetchURL = episodeURL.appending(queryItems: [
            URLQueryItem(name: "production", value: show)
        ])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
            
        let episodes = try decoder.decode([Episode].self, from: data)
        
        return episodes.randomElement()
    }
}
