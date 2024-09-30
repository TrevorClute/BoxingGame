//
//  JoyStickView.swift
//  Game
//
//  Created by Trevor Clute on 12/3/23.
//

import SwiftUI
import Combine


extension CGSize {
    func hyp() -> CGFloat {
        return ((self.width * self.width) + (self.height * self.height)).squareRoot()
    }
    func getAngle() -> Double {
        return atan(Double(abs(self.height) / abs(self.width))) * 180 / Double.pi
    }
}

func width(hyp: Double, angle: Double) -> Double {
    return hyp * cos(angle * Double.pi / 180)
}

func height(hyp: Double, angle: Double) -> Double {
    return hyp * sin(angle * Double.pi / 180)
}


class JoyStickViewModel: ObservableObject {
    var size:CGFloat
    var character:Character
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var offset:CGSize = .zero {
        didSet{
            let circleRadius = ((size / 2) - (size / 6))
            let angle = offset.getAngle()
            var width = width(hyp: circleRadius, angle: angle) - (circleRadius / 10)
            var height = height(hyp: circleRadius, angle: angle) - (circleRadius / 10)
            if offset.hyp() >= circleRadius {
                if offset.width.sign == .minus {
                    width = width * -1
                }
                if offset.height.sign == .minus {
                    height = height * -1
                }
                offset = CGSize(width: width, height: height)
            }
        }
    }
    
    init(size: CGFloat, character:Character) {
        self.size = size
        self.character = character
        
        $offset
            .sink { [weak self] offset in
                if let direction = self?.direct(from: offset) {
                    self?.character.direction = direction
                }
                
            }
            .store(in: &cancellables)
    }
    
    func direct(from offset:CGSize) -> Character.Direction {
        let x = abs(offset.width)
        let y = abs(offset.height)
        let widthSign = offset.width.sign
        let heightSign = offset.height.sign

        guard x != y else {return .none}

        if x > y {
            if widthSign == .plus {
                return .right
            }
            else {
                return .left
            }
        }
        if y > x {
            if heightSign == .plus {
                return .down
            }
            else {
                return .up
            }
        }
        return .none
    }
}

struct JoyStickView: View {
    @StateObject var vm: JoyStickViewModel
    
    init(size:CGFloat, character: Character){
        _vm = StateObject(wrappedValue: JoyStickViewModel(size: size, character: character))
    }
    
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: vm.size / 80)
                .frame(width: vm.size)
                .overlay {
                    Circle()
                        .frame(width: vm.size / 3)
                        .offset(vm.offset)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    withAnimation(.interactiveSpring){      vm.offset = value.translation
                                    }
                                })
                                .onEnded({ _ in
                                    withAnimation(.interactiveSpring){
                                        vm.offset = .zero
                                    }
                                })
                        )
                    
                }
            
        }
    }
}
 
/*
#Preview {
    JoyStickView(size: 200, character: Arrow(pace: 100, hitBox: .init(length: 100, width: 100)))
}
*/
