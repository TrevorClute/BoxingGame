//
//  HealthBarView.swift
//  Game
//
//  Created by Trevor Clute on 12/9/23.
//

import SwiftUI

struct HealthBarView: View {
    @ObservedObject var character:Character
    var width:CGFloat
    var height:CGFloat
    var innerWidth:CGFloat {
        return CGFloat(Double(character.curHealth) / Double(character.maxHealth)) * width
    }
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .overlay{
                HStack{
                    Rectangle()
                        .fill(.green)
                        .frame(width: innerWidth)
                        .clipShape(.capsule)
                        .overlay{
                            Text("\(self.character.curHealth) / \(self.character.maxHealth)")
                                .font(.system(size: 5))
                        }
                    if innerWidth != width {
                        Spacer()
                    }
                }
            }
            .clipShape(.capsule)
        
    }
}
 

/*
#Preview {
    HealthBarView(character: .init(pace: 200, hitBox: .init(length: 20, width: 20), position: .random(), maxHealth: 100, attackDamage: 10), width: 200, height: 100)
}
*/
