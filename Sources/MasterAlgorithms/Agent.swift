//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 25/05/23.
//

import Foundation

public enum AgentOrientation: String {
    case north = "NORTH"
    case south = "SOUTH"
    case east = "EAST"
    case west = "WEST"
}

public enum AgentDirection: String {
    case left = "LEFT"
    case right = "RIGHT"
    case up = "UP"
    case down = "DOWN"
}

extension BinaryInteger {
    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        var counter = 0

        for _ in (1...self.bitWidth) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
            counter += 1
            if counter % 4 == 0 {
                binaryString.insert(contentsOf: " ", at: binaryString.startIndex)
            }
        }

        return String(binaryString.dropFirst(1))
    }
}

extension Array {
    
    func pickRandom() -> Element? {
        var copy = self
        copy.sort(by: { _,_ in Bool.random() })
        return copy.first
    }
    
}
