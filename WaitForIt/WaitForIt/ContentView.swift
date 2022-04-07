//
//  ContentView.swift
//  WaitForIt
//
//  Created by junemp on 2022/04/07.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var jokeService = JokeService()
    
    var body: some View {
        
        ZStack {
            Text(jokeService.joke)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            VStack {
                Spacer()
                Button {
                    jokeService.fetchJoke()
                } label: {
                    Text("Fetch a joke")
                        .padding(.bottom)
                        .opacity(jokeService.isFetching ? 0 : 1)
                        .overlay {
                            if jokeService.isFetching { ProgressView() }
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
