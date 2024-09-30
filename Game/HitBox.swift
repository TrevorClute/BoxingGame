//
//  HitBox.swift
//  Game
//
//  Created by Trevor Clute on 12/6/23.
//

import Foundation
import SwiftUI


struct Edges {
    var left: CGFloat
    var right: CGFloat
    var top: CGFloat
    var bottom: CGFloat
}

struct HitBox {
    var length:CGFloat
    var width:CGFloat
    var halfLength:CGFloat
    var halfWidth:CGFloat
    var position:CGPoint = .zero
    
    
    init(length: CGFloat, width: CGFloat) {
        self.halfLength = length / 2
        self.halfWidth = width / 2
        self.length = length
        self.width = width
    }
    
    func show() -> some View {
        Rectangle()
            .stroke()
            .frame(width: halfLength, height: halfWidth)
            .position(self.position)
    }
    
    var edges: Edges {
        return Edges(left: position.x - halfWidth, right: position.x + halfWidth, top: position.y - halfLength, bottom: position.y + halfLength)
    }
}
