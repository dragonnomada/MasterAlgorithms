//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 18/05/23.
//

import Foundation

public typealias Wall = (indexA: RawIndex, indexB: RawIndex)

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
                
                if let indexA = matrix.getRawIndex(at: (i, j)) {
                    if up {
                        if let indexB = matrix.selectRawIndex(from: indexA, direction: .up) {
                            if !walls.contains(where: { $0.indexA == indexA && $0.indexB == indexB }) {
                                walls.append((indexA, indexB))
                            }
                            if !walls.contains(where: { $0.indexA == indexB && $0.indexB == indexA }) {
                                walls.append((indexB, indexA))
                            }
                        }
                    }
                    if down {
                        if let indexB = matrix.selectRawIndex(from: indexA, direction: .down) {
                            if !walls.contains(where: { $0.indexA == indexA && $0.indexB == indexB }) {
                                walls.append((indexA, indexB))
                            }
                            if !walls.contains(where: { $0.indexA == indexB && $0.indexB == indexA }) {
                                walls.append((indexB, indexA))
                            }
                        }
                    }
                    if left {
                        if let indexB = matrix.selectRawIndex(from: indexA, direction: .left) {
                            if !walls.contains(where: { $0.indexA == indexA && $0.indexB == indexB }) {
                                walls.append((indexA, indexB))
                            }
                            if !walls.contains(where: { $0.indexA == indexB && $0.indexB == indexA }) {
                                walls.append((indexB, indexA))
                            }
                        }
                    }
                    if right {
                        if let indexB = matrix.selectRawIndex(from: indexA, direction: .right) {
                            if !walls.contains(where: { $0.indexA == indexA && $0.indexB == indexB }) {
                                walls.append((indexA, indexB))
                            }
                            if !walls.contains(where: { $0.indexA == indexB && $0.indexB == indexA }) {
                                walls.append((indexB, indexA))
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
    
    init(debug: Bool = true, name: String = "default", position: MatrixIndex = (0, 0), orientation: FloodFillAgentOrientation = .south, matrixWall: MatrixWall = MatrixWall(matrix: Matrix.squared(2), walls: []), stack: [Int] = [], visited: [Int] = [], backStack: [Int] = []) {
        self.init(
            debug: debug,
            name: name,
            position: position,
            orientation: orientation,
            matrix: matrixWall.matrix,
            walls: matrixWall.walls,
            stack: stack,
            visited: visited,
            backStack: backStack
        )
    }
    
}
