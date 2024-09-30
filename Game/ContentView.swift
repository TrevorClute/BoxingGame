//
//  ContentView.swift
//  Game
//
//  Created by Trevor Clute on 12/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{ proxy in
            NavigationStack{
                NavigationLink{
                    Game(
                        char: .init(
                            pace: 500,
                            hitBox: .init(length: 20, width: 20),
                            position: .random(),
                            maxHealth: 150,
                            attackDamage: 10,
                            flip: false,
                            attackBox: .init(
                                length: 80,
                                width: 80
                            ),
                            knockback: 45,
                            proxy: proxy
                        ),
                        char2: .init(
                            pace: 100,
                            hitBox: .init(length: 20, width: 20),
                            position: .random(),
                            maxHealth: 300,
                            attackDamage: 20,
                            flip: true,
                            attackBox: .init(length: 200, width: 200),
                            knockback: 200,
                            proxy: proxy
                        ),
                        proxy: proxy
                    )
                } label: {
                    Text("start game")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
