//
//  AttackButtonview.swift
//  Game
//
//  Created by Trevor Clute on 12/8/23.
//

import SwiftUI

class AttackButtonViewModel:ObservableObject{
    @Published var isOnCooldown:Bool = false
    
    func startCoolDown() {
        isOnCooldown = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.isOnCooldown = false
        }
    }
}

struct AttackButtonView: View {
    @StateObject var vm = AttackButtonViewModel()
    
    var character:Character
    init(character: Character){
        self.character = character
    }
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .fill(self.vm.isOnCooldown ? .red : .blue)
            .opacity(0.4)
            .overlay{
                Circle()
                    .opacity(0.01)
                    .overlay{
                        Text("attack")
                            .font(.title2.smallCaps().bold())
                            .strikethrough(self.vm.isOnCooldown, color: .red)
                            
                    }
            }
            .onTapGesture {
                if !self.vm.isOnCooldown {
                    character.isHitting = true
                    self.vm.startCoolDown()
                }
            }
    }
}
/*
 #Preview {
 AttackButtonView(character: .init(pace: 100, hitBox: .init(length: 20, width: 20)))
 }
 */
