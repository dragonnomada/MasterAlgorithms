//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 18/05/23.
//

import Foundation

public typealias Wall = (aRawIndex: RawIndex, bRawIndex: RawIndex)

public struct MatrixWall {
    
    public var matrix: Matrix
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
    
    init(debug: Bool = true, name: String = "default", position: MatrixIndex = (0, 0), orientation: AgentOrientation = .south, matrixWall: MatrixWall = MatrixWall(matrix: Matrix.squared(2), walls: []), stack: [Int] = [], visited: [Int] = [], backStack: [Int] = [], metrics: [String:Int] = [:]) {
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

public extension Matrix {
    func describe(withWalls walls: [Wall], position: MatrixIndex = (row: 0, column: 0), visited: [RawIndex] = [], stack: [RawIndex] = []) {
        let matrix = self
        
        for rowIndex in 0..<matrix.rows {
            
            // TOP
            for columnIndex in 0..<matrix.columns {
                guard let index = matrix.getRawIndex(at: (rowIndex, columnIndex))
                else { continue }
                let indexUp = matrix.selectRawIndex(from: index, direction: .up)
                let indexLeft = matrix.selectRawIndex(from: index, direction: .left)
                let indexRight = matrix.selectRawIndex(from: index, direction: .right)
                
                var left = false
                
                // LEFT
                if walls.contains(where: { $0 == index && $1 == indexLeft }) {
                    left = true
                }
                if columnIndex == 0 {
                    left = true
                }
                
                var right = false
                
                // RIGHT
                if walls.contains(where: { $0 == index && $1 == indexRight }) {
                    right = true
                }
                if columnIndex == matrix.lastColumn {
                    right = true
                }
                
                if walls.contains(where: { $0 == index && $1 == indexUp }) {
                    print("\(left ? "|" : "=")=====\(right ? "|" : "=")", terminator: "")
                } else {
                    if rowIndex == 0 {
                        print("\(left ? "+" : "=")=====\(right ? "+" : "=")", terminator: "")
                    } else {
                        print("\(left ? "|" : " ")     \(right ? "|" : " ")", terminator: "")
                    }
                }
            }
            print()
            
            for columnIndex in 0..<matrix.columns {
                
                guard let index = matrix.getRawIndex(at: (rowIndex, columnIndex))
                else { continue }
                //let indexUp = matrix.selectRawIndex(from: index, direction: .up)
                let indexLeft = matrix.selectRawIndex(from: index, direction: .left)
                let indexRight = matrix.selectRawIndex(from: index, direction: .right)
                
                guard let value = matrix.getValue(from: index)
                else { continue }
                
                var left = " "
                
                // LEFT
                if let _ = walls.first(where: { $0 == index && $1 == indexLeft }) {
                    left = "|"
                }
                if columnIndex == 0 {
                    left = "|"
                }
                
                var right = " "
                
                // RIGHT
                if let _ = walls.first(where: { $0 == index && $1 == indexRight }) {
                    right = "|"
                }
                if columnIndex == matrix.lastColumn {
                    right = "|"
                }
                
                var symbol = " \(value < 0 ? " * " : "\(String(format: "%03d", value))") "
                
                var isStacked = false
                var isVisited = false
                
                if let _ = stack.first(where: { $0 == index }) {
                    isStacked = true
                }
                
                if let _ = visited.first(where: { $0 == index }) {
                    isVisited = true
                }
                
                if position.row == rowIndex && position.column == columnIndex {
                    symbol = "<\(value < 0 ? " * " : "\(String(format: "%03d", value))")>"
                } else {
                    if isStacked {
                        if isVisited {
                            symbol = "{\(value < 0 ? " * " : "\(String(format: "%03d", value))")}"
                        } else {
                            symbol = "[\(value < 0 ? " * " : "\(String(format: "%03d", value))")]"
                        }
                    } else {
                        if isVisited {
                            symbol = "(\(value < 0 ? " * " : "\(String(format: "%03d", value))"))"
                        }
                    }
                }
                
                print("\(left)\(symbol)\(right)", terminator: "")
                
            }
            print()
            
        }
        
        // DOWN
        for j in 0..<matrix.columns {
            print("\(j == matrix.firstColumn ? "+" : "=")=====\(j == matrix.lastColumn ? "+" : "=")", terminator: "")
        }
        print()
    }
}

public extension MatrixWall {
    func describe(position: MatrixIndex = (row: 0, column: 0), visited: [RawIndex] = [], stack: [RawIndex] = []) {
        matrix.describe(withWalls: walls, position: position, visited: visited, stack: stack)
    }
    
}
