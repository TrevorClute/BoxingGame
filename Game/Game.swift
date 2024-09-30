//
//  ContentView.swift
//  Game
//
//  Created by Trevor Clute on 12/3/23.
//

import SwiftUI
import Combine

class Square: UICharacter {
    func display() -> some View {
        Rectangle()
            .frame(width: 20, height: 20)
            .position(self.position)
    }
}




struct Game: View {
    @ObservedObject var character: Ash
    
    @ObservedObject var character2: Ash
    
    @ObservedObject var map:Map
    
    @State var isCharacterOne = true
    
    var proxy:GeometryProxy
    
    init(char: Ash, char2: Ash, proxy:GeometryProxy){
        self.proxy = proxy
        self.character = char
        self.character2 = char2
        map = .init(mainCharacter: char, otherCharacters: [char2])
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(lineWidth: 5)
                .frame(maxWidth: .infinity)
                .frame(width: proxy.size.width * 0.8 ,height: proxy.size.height * 0.6)
                .offset(y: -proxy.size.height * 0.05)

            character2.display()
                .colorMultiply(.red)
            HealthBarView(character: character2, width: 100, height: 10)
                .position(CGPoint(x: character2.position.x, y: character2.position.y - 40))
                
                .onTapGesture {
                    print(character2.position)
                    print(character.position)
                }
            
            character.display()
                .colorMultiply(.init(red: 0, green: 0.9, blue: 1))
                
            HealthBarView(character: character, width: 50, height: 10)
                .position(CGPoint(x: character.position.x, y: character.position.y - 40))
            
            
            
            HStack{
                JoyStickView(size: 100, character: character)
                Spacer()
                AttackButtonView(character: character)
                    .frame(width: 100, height: 100)
            }
            .frame(maxWidth: .infinity)
            .offset(y: proxy.size.height * 0.35)
            .padding(40)
            .padding(.vertical, 20)



            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}
/*
#Preview {
    Game(
        char: Ash(
            pace: 400,
            hitBox: HitBox(length: 20, width: 20),
            position: .random(),
            maxHealth: 100,
            attackDamage: 10,
            flip: false,
            attackBox: .init(length: 80, width: 80),
            knockback: 40
        ),
        char2: Ash(
            pace: 100,
            hitBox: HitBox(length: 20, width: 20),
            position: .random(),
            maxHealth: 300,
            attackDamage: 20,
            flip: true,
            attackBox: .init(length: 200, width: 200),
            knockback: 200
        )
    )
}
*/
