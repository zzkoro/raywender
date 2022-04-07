//
//  JokeService.swift
//  WaitForIt
//
//  Created by junemp on 2022/04/07.
//

import Foundation

class JokeService: ObservableObject {
    @Published private(set) var joke = "Joke appears here"
    @Published private(set) var isFetching = false
    private var url: URL {
        urlComponents.url!
    }
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.chucknorris.io"
        components.path = "/jokes/random"
        components.setQueryItems(with: ["category": "dev"])
        return components
    }
    
    public init() { }
}

extension JokeService {
    func fetchJoke() {
        isFetching = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.isFetching = false
                }
            }
            if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data) {
                    DispatchQueue.main.async {
                        self.joke = decodedResponse.value
                    }
                    return
                }
            }
            print("Joke fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()
    }
}

struct Joke: Codable {
    let value: String
}

public extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}

