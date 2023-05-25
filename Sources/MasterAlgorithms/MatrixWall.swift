//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 18/05/23.
//

import Foundation

public typealias Wall = (aRawIndex: RawIndex, bRawIndex: RawIndex)

public struct MatrixWall {
    
    public let matrix: Matrix
    public let walls: [Wall]
    
    public init(matrix: Matrix, walls: [Wall]) {
        self.matrix = matrix
        self.walls = walls
    }
    
    public static func build(_ matrixEncondingWalls: [[Int]]) -> MatrixWall {
        
        let matrix = Matrix(rows: matrixEncondingWalls.count, columns: matrixEncondingWalls.first!.count)
        
        var walls: [Wall] = []
        
        for i in 0..<matrix.rows {
            for j in 0..<matrix.columns {
                let encoded = matrixEncondingWalls[i][j]
                
                //print("Encoded: \(encoded)")
               
                let down = encoded % 2 == 1
                let right = Int(encoded / 10) % 2 == 1
                let up = Int(encoded / 100) % 2 == 1
                let left = Int(encoded / 1000) % 2 == 1
                
                //print("[ \(left ? "L" : "-") \(up ? "U" : "-") \(right ? "R" : "-") \(down ? "D" : "-") ]")
                
                if let aRawIndex = matrix.getRawIndex(at: (i, j)) {
                    if up {
                        if let bRawIndex = matrix.selectRawIndex(from: aRawIndex, direction: .up) {
                            if !walls.contains(where: { $0.aRawIndex == aRawIndex && $0.bRawIndex == bRawIndex }) {
                                walls.append((aRawIndex, bRawIndex))
                            }
                            if !walls.contains(where: { $0.aRawIndex == bRawIndex && $0.bRawIndex == aRawIndex }) {
                                walls.append((bRawIndex, aRawIndex))
                            }
                        }
                    }
                    if down {
                        if let bRawIndex = matrix.selectRawIndex(from: aRawIndex, direction: .down) {
                            if !walls.contains(where: { $0.aRawIndex == aRawIndex && $0.bRawIndex == bRawIndex }) {
                                walls.append((aRawIndex, bRawIndex))
                            }
                            if !walls.contains(where: { $0.aRawIndex == bRawIndex && $0.bRawIndex == aRawIndex }) {
                                walls.append((bRawIndex, aRawIndex))
                            }
                        }
                    }
                    if left {
                        if let bRawIndex = matrix.selectRawIndex(from: aRawIndex, direction: .left) {
                            if !walls.contains(where: { $0.aRawIndex == aRawIndex && $0.bRawIndex == bRawIndex }) {
                                walls.append((aRawIndex, bRawIndex))
                            }
                            if !walls.contains(where: { $0.aRawIndex == bRawIndex && $0.bRawIndex == aRawIndex }) {
                                walls.append((bRawIndex, aRawIndex))
                            }
                        }
                    }
                    if right {
                        if let bRawIndex = matrix.selectRawIndex(from: aRawIndex, direction: .right) {
                            if !walls.contains(where: { $0.aRawIndex == aRawIndex && $0.bRawIndex == bRawIndex }) {
                                walls.append((aRawIndex, bRawIndex))
                            }
                            if !walls.contains(where: { $0.aRawIndex == bRawIndex && $0.bRawIndex == aRawIndex }) {
                                walls.append((bRawIndex, aRawIndex))
                            }
                        }
                    }
                }
            }
        }
        
        return MatrixWall(matrix: matrix, walls: walls)
    }
    
}

public extension FloodFillAgent {
    
    init(debug: Bool = true, name: String = "default", position: MatrixIndex = (0, 0), orientation: FloodFillAgentOrientation = .south, matrixWall: MatrixWall = MatrixWall(matrix: Matrix.squared(2), walls: []), stack: [Int] = [], visited: [Int] = [], backStack: [Int] = [], metrics: [String:Int] = [:]) {
        self.init(
            debug: debug,
            name: name,
            position: position,
            orientation: orientation,
            matrix: matrixWall.matrix,
            walls: matrixWall.walls,
            stack: stack,
            visited: visited,
            backStack: backStack,
            metrics: metrics
        )
    }
    
}
