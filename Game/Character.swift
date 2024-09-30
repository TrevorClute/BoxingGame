//
//  Character.swift
//  Game
//
//  Created by Trevor Clute on 12/6/23.
//

import Foundation
import SwiftUI
import Combine


typealias UICharacter = Character & DisplayableCharacter

protocol DisplayableCharacter: ObservableObject {
    associatedtype T:View
    func display() -> T
}

class Character: ObservableObject {
    enum Direction: String {
        case left
        case right
        case up
        case down
        case none
    }
    
    @Published var isHitting:Bool = false
    
    @Published var position:CGPoint = .random() {
        didSet {
            self.hitBox.position = position
            if position.x < proxy.size.width * 0.1{
                position = CGPoint(x: proxy.size.width * 0.11, y: position.y)
            }
            if position.x >= proxy.size.width * 0.9 {
                position = CGPoint(x: proxy.size.width * 0.89, y: position.y)
            }
            if position.y < proxy.size.height * 0.1 {
                position = CGPoint(x: position.x, y: proxy.size.height * 0.105)
            }
            if position.y >=  proxy.size.height * 0.7 {
                position = CGPoint(x: position.x, y:  proxy.size.height * 0.695)
            }
            
        }
    }
    
    var facing: Character.Direction = .up {
        didSet{
            if facing == .none {
                facing = oldValue
            }
        }
    }
    
    var direction: Character.Direction = .none {
        didSet {
            facing = direction
        }
    }
    
    var isMoving: Bool {
        return direction != .none
    }
    
    var cantGo:Character.Direction = .none
    
    var hitBox: HitBox
    
    var attackBox: HitBox
    
    var maxHealth:Int
    
    var isAlive = true
    
    var isBeingHit = false
    
    @Published private(set) var curHealth:Int
    
    func setHealth(damageTaken:Int){
        self.curHealth -= damageTaken
        if curHealth < 0{
            curHealth = 0
            isAlive = false
        }
        
    }
    
    var attackDamage:Int
    
    var cancellables = Set<AnyCancellable>()
    
    var flip:Bool
    
    var knockback:CGFloat
    
    var proxy:GeometryProxy
    
    
    
    init(pace:Double, hitBox: HitBox, position:CGPoint, maxHealth:Int, attackDamage:Int, flip:Bool, attackBox:HitBox, knockback:CGFloat, proxy:GeometryProxy){
        self.proxy = proxy
        self.knockback = knockback
        self.attackBox = attackBox
        self.flip = flip
        self.attackDamage = attackDamage
        self.maxHealth = maxHealth
        self.curHealth = maxHealth
        self.position = position
        self.attackBox.position = .init(x: position.x, y: position.y - 50 )
        self.hitBox = hitBox
        self.hitBox.position = self.position
        Timer.publish(every: 1/pace, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { value in
                Task {
                    await MainActor.run {
                        self.move(self.direction)
                        if self.isHitting{
                            self.hit(self.facing)
                        }
                    }
                }
                
            }
            .store(in: &cancellables)
        
        
    }
    
    
    func hit(_ direction: Character.Direction){
        switch direction {
        case .left:
            self.attackBox.position = .init(x: self.position.x - attackBox.halfWidth, y: self.position.y)
        case .right:
            self.attackBox.position = .init(x: self.position.x + attackBox.halfWidth, y: self.position.y)
        case .up:
            self.attackBox.position = .init(x: self.position.x, y: self.position.y - attackBox.halfLength)
        case .down:
            self.attackBox.position = .init(x: self.position.x, y: self.position.y + attackBox.halfLength)
        default:
            break
        }
    }
    
    private func move(_ direction:Character.Direction){
        guard isAlive else {return}
            switch direction {
            case .left:
                if self.cantGo != .left{
                    position = CGPoint(x: position.x - 1, y: position.y)
                }
                break
            case .right:
                if self.cantGo != .right{
                    position = CGPoint(x: position.x + 1, y: position.y)
                }
                break
            case .up:
                if self.cantGo != .up {
                    position = CGPoint(x: position.x, y: position.y - 1)
                }
                break
            case .down:
                if self.cantGo != .down {
                    position = CGPoint(x: position.x, y: position.y + 1)
                }
                break
            case .none:
                break
            }
        
        

    }
}

