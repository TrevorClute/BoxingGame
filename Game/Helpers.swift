//
//  Helpers.swift
//  Game
//
//  Created by Trevor Clute on 12/6/23.
//

import Foundation

extension CGPoint {
    static func random() -> CGPoint {
        return CGPoint(x: Int.random(in: 11...350), y: Int.random(in: 11...700))
    }
}
