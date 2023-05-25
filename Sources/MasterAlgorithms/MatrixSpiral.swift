//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 24/05/23.
//

import Foundation

public typealias MatrixNeighbor = (value: Int, index: MatrixIndex, rawIndex: RawIndex, direction: MatrixDirection)
public typealias RawIndexRelation = (aRawIndex: RawIndex, bRawIndex: RawIndex)

public struct MatrixSpiral {
    
    public let matrix: Matrix
    
    public init(dimension n: Int) {
        let size = n % 2 == 1 ? n : n + 1
        
        var matrix = Matrix(rows: size, columns: size, defaultValue: 0)
        
        var count = 1
        
        let m = size / 2
        
        var position = (row: m, column: m)
        
        var direction = MatrixDirection.right
        var distance = 1
        var i: Int
        
        matrix.setValue(count, at: position)
        count += 1
        
        while count <= matrix.size {
            switch direction {
            case .left:
                i = distance
                while i > 0 {
                    position.column -= 1
                    matrix.setValue(count, at: position)
                    count += 1
                    i -= 1
                }
                direction = .down
            case .right:
                i = distance
                while i > 0 {
                    position.column += 1
                    matrix.setValue(count, at: position)
                    count += 1
                    i -= 1
                }
                direction = .up
            case .up:
                i = distance
                while i > 0 {
                    position.row -= 1
                    matrix.setValue(count, at: position)
                    count += 1
                    i -= 1
                }
                direction = .left
                distance += 1
            case .down:
                i = distance
                while i > 0 {
                    position.row += 1
                    matrix.setValue(count, at: position)
                    count += 1
                    i -= 1
                }
                direction = .right
                distance += 1
            }
        }
        
        self.matrix = matrix
    }
    
    public func describe() {
        matrix.describe()
    }
    
    public func searchRawIndex(value: Int) -> RawIndex? {
        for index in 0..<matrix.size {
            if matrix.getValue(from: index) == value {
                return index
            }
        }
        return nil
    }
    
    public func searchIndex(value: Int) -> MatrixIndex? {
        guard let index = searchRawIndex(value: value)
        else { return nil }
        return matrix.getIndex(from: index)
    }
    
    public func neighbors(at index: MatrixIndex) -> [MatrixNeighbor] {
        var neighbors: [MatrixNeighbor] = []
        
        let directions: [MatrixDirection] = [.right, .up, .left, .down]
        
        for direction in directions {
            if let nextIndex = matrix.selectRawIndex(at: index, direction: direction) {
                if let value = matrix.getValue(from: nextIndex) {
                    if let matrixIndex = matrix.getIndex(from: nextIndex) {
                        neighbors.append((value: value, index: matrixIndex, rawIndex: nextIndex, direction: direction))
                    }
                }
            }
        }
        
        return neighbors
    }
    
    public func neighbors(from rawIndex: RawIndex) -> [MatrixNeighbor] {
        guard let index = matrix.getIndex(from: rawIndex)
        else { return [] }
        return neighbors(at: index)
    }
    
    public func neighbors(of value: Int) -> [MatrixNeighbor] {
        guard let index = searchIndex(value: value)
        else { return [] }
        return neighbors(at: index)
    }
    
    public func relations() -> [(Int, Int)] {
        var relations: [(Int, Int)] = []
        
        for value in 1...matrix.size {
            let neighbors = self.neighbors(of: value)
            for neighbor in neighbors {
                relations.append((value, neighbor.value))
            }
        }
        
        relations.sort(by: { (pair1, pair2) in
            if pair1.0 == pair2.0 {
                return pair1.1 < pair2.1
            }
            return pair1.0 < pair2.0
        })
        
        return relations
    }
    
    public func walls() -> [Wall] {
        var walls: [Wall] = []
        
        for (aValue, bValue) in relations() {
            if let aIndex = searchRawIndex(value: aValue), let bIndex = searchRawIndex(value: bValue) {
                walls.append((aRawIndex: aIndex, bRawIndex: bIndex))
            }
        }
        
        return walls
    }
    
}
