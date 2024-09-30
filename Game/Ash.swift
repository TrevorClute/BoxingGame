//
//  Ash.swift
//  Game
//
//  Created by Trevor Clute on 12/8/23.
//

import Foundation
import SwiftUI
import Combine

class Ash: UICharacter {
    func display() -> some View {
        ZStack{
            if self.isAlive {
                Image(curFrame)
                    .position(self.position)
            }
            else {
                Image(systemName: "x.circle")
                    .position(self.position)
            }
            
            if showSlash {
                Image(slash.cur)
                    .resizable()
                    .frame(width: self.attackBox.width, height: self.attackBox.length)
                    .rotationEffect(self.displayRotate)
                    .position(self.attackBox.position)
                    .colorMultiply(.blue)

            }
        }
        //.rotationEffect(self.flip ? .degrees(180) : .degrees(0))
       
    }
    
    var down = Frame(frames: ["ash.down0","ash.down1","ash.down2","ash.down3"])
    var up = Frame(frames: ["ash.up0","ash.up1","ash.up2","ash.up3"])
    var left = Frame(frames: ["ash.left0","ash.left1","ash.left2","ash.left3"])
    var right = Frame(frames: ["ash.right0","ash.right1","ash.right2","ash.right3"])
    
    var slash = Frame(frames: ["slash0","slash1","slash2","slash3"])
    
    var showSlash:Bool = false
    
    var displayRotate:Angle = .degrees(0)
    
    var rotate: Angle {
        switch self.facing{
        case .right:
            return .degrees(0)
        case .left:
            return .degrees(180)
        case .down:
            return .degrees(90)
        case .up:
            return .degrees(270)
        default:
            return .degrees(0)
        }
    }
    
    var curFrame: String {
        switch facing {
        case .left:
            return left.cur
        case .right:
            return right.cur
        case .up:
            return up.cur
        case .down:
            return down.cur
        default:
            return "ash.up0"
        }
    }
    
    

    override init(pace: Double, hitBox: HitBox, position:CGPoint, maxHealth:Int, attackDamage:Int, flip:Bool, attackBox:HitBox, knockback:CGFloat, proxy:GeometryProxy) {

        
        super.init(pace: pace, hitBox: hitBox, position: position, maxHealth: maxHealth, attackDamage: attackDamage, flip: flip, attackBox: attackBox, knockback: knockback, proxy: proxy)
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                if self.isMoving {
                    switch self.facing {
                    case .left:
                        self.left.iterate()
                    case .right:
                        self.right.iterate()
                    case .up:
                        self.up.iterate()
                    case .down:
                        self.down.iterate()
                    default:
                        break
                    }
                }
                else {
                    //print("not moving")
                    switch self.facing {
                    case .left:
                        self.left.reset()
                    case .right:
                        self.right.reset()
                    case .up:
                        self.up.reset()
                    case .down:
                        self.down.reset()
                    default:
                        break
                    }
                    self.position = self.position
                }
                
                if self.isHitting {
                    self.showSlash = true
                    let startDirection = self.rotate
                    self.displayRotate = startDirection
                    Task{
                        
                        
                        try? await Task.sleep(for: .seconds(0.05))
                        self.slash.iterate()
                        try? await Task.sleep(for: .seconds(0.05))
                        self.slash.iterate()
                        try? await Task.sleep(for: .seconds(0.05))
                        self.slash.iterate()
                        try? await Task.sleep(for: .seconds(0.05))
                        self.showSlash = false
                        self.slash.reset()
                    }
                }
            }
            .store(in: &cancellables)
    }
}


struct Frame {
    var frames:[String]
    var index:Int = 0
    var cur:String {
        return frames[index]
    }
    mutating func iterate(){
        if index == frames.count - 1 {
            index = 0
        }
        else {
            index += 1
        }
    }
    mutating func reset(){
        index = 0
    }
    
}
