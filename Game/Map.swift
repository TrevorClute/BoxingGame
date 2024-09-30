//
//  Map.swift
//  Game
//
//  Created by Trevor Clute on 12/6/23.
//

import Foundation
import Combine
import SwiftUI

class Map: ObservableObject {
    
    
    var mainCharacter:Character
    var otherCharacters:[Character]
    private var cancellables = Set<AnyCancellable>()
    
    init(mainCharacter: Character, otherCharacters: [Character]) {
        self.otherCharacters = otherCharacters
        self.mainCharacter = mainCharacter
        
        
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                for (_, character) in otherCharacters.enumerated(){
                    if self.mainCharacter.isHitting {
                            if self.isTouching(mainCharacter.attackBox.edges, and: character.hitBox.edges) {
                                
                                withAnimation(.interactiveSpring){
                                    switch mainCharacter.facing {
                                    case .left:
                                        character.position.x -= mainCharacter.knockback
                                    case .right:
                                        character.position.x += mainCharacter.knockback
                                    case .up:
                                        character.position.y -= mainCharacter.knockback
                                    case .down:
                                        character.position.y += mainCharacter.knockback
                                    default:
                                        break
                                    }
                                    character.setHealth(damageTaken: mainCharacter.attackDamage)
                                }
                               
                                
                        }
                        
                        self.mainCharacter.isHitting = false
                    }
                    if self.isTouching(self.mainCharacter.hitBox.edges, and: character.hitBox.edges){
                        self.mainCharacter.cantGo = self.findClosestDirection(from: mainCharacter, to: character)
                        character.cantGo = self.findClosestDirection(from: character, to: mainCharacter)
                    }else {
                        character.cantGo = .none
                        mainCharacter.cantGo = .none
                    }

                }
                
                for character in otherCharacters {
                    if character.isHitting {
                    if self.isTouching(character.attackBox.edges, and: mainCharacter.hitBox.edges) {
                        
                        withAnimation(.interactiveSpring){
                            switch character.facing {
                            case .left:
                                mainCharacter.position.x -= character.knockback
                            case .right:
                                mainCharacter.position.x += character.knockback
                            case .up:
                                mainCharacter.position.y -= character.knockback
                            case .down:
                                mainCharacter.position.y += character.knockback
                            default:
                                break
                            }
                            mainCharacter.setHealth(damageTaken: character.attackDamage)
                        }
                       
                    }
                    character.isHitting = false
                }
                }
            }
            .store(in: &cancellables)
        
        //bot
       
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                for character in otherCharacters{
                    character.direction = self.findClosestDirection(from: character, to: mainCharacter)
                }
            }
            .store(in: &cancellables)
        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                for character in otherCharacters{
                    if (self.isTouching(mainCharacter.hitBox.edges, and: character.attackBox.edges)){
                        character.isHitting = true
                    }
                }
            }
            .store(in: &cancellables)
         
         
    }
    
    private func isTouching(_ boxOne:Edges, and boxTwo:Edges) -> Bool{
        return (((boxOne.left <= boxTwo.right) && (boxOne.left >= boxTwo.left)) || ((boxOne.right >= boxTwo.left) && (boxOne.right <= boxTwo.right)) || ((boxOne.right >= boxTwo.right) && (boxOne.left <= boxTwo.left))) && ((boxOne.bottom >= boxTwo.top && boxOne.bottom <= boxTwo.bottom) || (boxOne.top <= boxTwo.bottom && boxOne.top >= boxTwo.top) || (boxOne.bottom >= boxTwo.bottom && boxOne.top <= boxTwo.top))
    }
    
    private func findClosestDirection(from character1: Character, to character2: Character) -> Character.Direction {
        let x = character2.position.x - character1.position.x
        let y = character1.position.y - character2.position.y
        if abs(x) > abs(y) {
            switch x.sign {
            case .plus:
                return .right
            case .minus:
                return .left
            }
        }
        else {
            switch y.sign {
            case .plus:
                return .up
            case .minus:
                return .down
            }
        }
        
    }
}
