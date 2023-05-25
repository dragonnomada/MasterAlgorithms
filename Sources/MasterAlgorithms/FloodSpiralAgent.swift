//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 25/05/23.
//

import Foundation

public enum FloodSpiralAgentError: Error {
    case indexNotExists
}

public struct FloodSpiralAgent {
    
    public let matrix: MatrixSpiral
    
    public var maze: MatrixWall
    
    public var position: MatrixIndex
    
    public var index: RawIndex? {
        maze.matrix.getRawIndex(at: position)
    }
    
    public var stack: [RawIndex] = []
    
    public var visited: [RawIndex] = []
    
    public var movements: [(rawIndex: RawIndex, direction: MatrixDirection)] = []
    
    public var direction: MatrixDirection = .right
    
    public var backDirection: MatrixDirection {
        switch direction {
        case .left:
            return .right
        case .right:
            return .left
        case .up:
            return .down
        case .down:
            return .up
        }
    }
    
    public var spiralValue: Int = 1
    
    public var count = 0
    
    public init(maze: [[Int]], position: MatrixIndex = (row: 0, column: 0)) {
        self.maze = MatrixWall.build(maze)
        
        self.maze.matrix.setValue(count, at: position)
        count += 1
        
        self.position = position
        
        self.matrix = MatrixSpiral(dimension: 2 * max(self.maze.matrix.rows, self.maze.matrix.columns))
        
        if let index = self.maze.matrix.getRawIndex(at: position) {
            self.visited.append(index)
        }
    }
    
    public func scanWall() throws -> Bool {
        print("SCAN WALL: \(position) \(direction.rawValue)")
        
        guard let index = index
        else { throw FloodSpiralAgentError.indexNotExists }
        
        guard let nextIndex = maze.matrix.selectRawIndex(from: index, direction: direction)
        else { throw FloodSpiralAgentError.indexNotExists }
        
        let isWall = maze.walls.contains(where: { $0.aRawIndex == index && $0.bRawIndex == nextIndex })
        
        print("SCAN WALL RESULT: \(position) \(direction.rawValue) \(isWall ? "WALL" : "EMPTY")")
        
        return isWall
    }
    
    mutating func turnLeft() {
        print("TURN-LEFT FROM DIRECTION: \(direction.rawValue)")
        switch direction {
        case .left:
            direction = .down
        case .right:
            direction = .up
        case .up:
            direction = .left
        case .down:
            direction = .right
        }
        print("TURN-LEFT NEW DIRECTION: \(direction.rawValue)")
    }
    
    mutating func turnRight() {
        print("TURN-RIGHT FROM DIRECTION: \(direction.rawValue)")
        switch direction {
        case .left:
            direction = .up
        case .right:
            direction = .down
        case .up:
            direction = .right
        case .down:
            direction = .left
        }
        print("TURN-RIGHT NEW DIRECTION: \(direction.rawValue)")
    }
    
    mutating public func turnAlign(direction: MatrixDirection) {
        print("TURN-ALIGN FROM DIRECTION: \(self.direction.rawValue) TO \(direction.rawValue)")
        
        switch self.direction {
        case .left:
            switch direction {
            case .left:
                print("Not necessary to turn align")
            case .right:
                turnRight()
                turnRight()
            case .up:
                turnRight()
            case .down:
                turnLeft()
            }
        case .right:
            switch direction {
            case .left:
                turnLeft()
                turnLeft()
            case .right:
                print("Not necessary to turn align")
            case .up:
                turnLeft()
            case .down:
                turnRight()
            }
        case .up:
            switch direction {
            case .left:
                turnLeft()
            case .right:
                turnRight()
            case .up:
                print("Not necessary to turn align")
            case .down:
                turnLeft()
                turnLeft()
            }
        case .down:
            switch direction {
            case .left:
                turnRight()
            case .right:
                turnLeft()
            case .up:
                turnRight()
                turnRight()
            case .down:
                print("Not necessary to turn align")
            }
        }
        
        print("TURN-ALIGN NEW DIRECTION: \(self.direction.rawValue)")
    }
    
    mutating public func turnBackward() {
        print("TURN-BACKWARD FROM DIRECTION: \(self.direction.rawValue)")
        turnAlign(direction: backDirection)
        print("TURN-BACKWARD NEW DIRECTION: \(self.direction.rawValue)")
    }
    
    mutating public func forward() {
        print("FORWARD FROM: \(position) \(direction.rawValue)")
        
        if let index = index {
            movements.append((rawIndex: index, direction: direction))
        }
        
        if let newPosition = maze.matrix.selectIndex(at: position, direction: direction) {
            position = newPosition
        }
        
        if let spiralRawIndex = matrix.searchRawIndex(value: spiralValue) {
            if let nextSpiralIndex = matrix.matrix.selectRawIndex(from: spiralRawIndex, direction: direction) {
                if let nextSpiralValue = matrix.matrix.getValue(from: nextSpiralIndex) {
                    spiralValue = nextSpiralValue
                }
            }
        }
        
        if let index = index {
            visited.append(index)
        }
        
        maze.matrix.setValue(count, at: position)
        count += 1
        
        print("FORWARD SUCCESS: \(position) \(direction.rawValue)")
    }
    
    mutating public func searchMinimumNeighbor() -> (value: Int?, direction: MatrixDirection?, total: Int) {
        print("SEARCHING MINIMUM NEIGHBOR: \(position) \(direction.rawValue)")
        guard let index = matrix.searchRawIndex(value: spiralValue)
        else { return (value: nil, direction: nil, total: 0) }
        
        print("SEARCHING MINIMUM NEIGHBOR: VALUE \(spiralValue) INTERNAL INDEX: \(index)")
        
        var minNeighbor: Int? = nil
        var minDirection: MatrixDirection? = nil
        
        var totalNeighbors = 0
        
        for neighbor in matrix.neighbors(from: index) {
            turnAlign(direction: neighbor.direction)
            
            if let isWall = try? scanWall() {
                if isWall { continue }
            }
            
            if let nextRawIndex = maze.matrix.selectRawIndex(at: position, direction: neighbor.direction) {
                if !visited.contains(where: { $0 == nextRawIndex }) {
                    totalNeighbors += 1
                    if let value = minNeighbor {
                        if value > neighbor.value {
                            minNeighbor = neighbor.value
                            minDirection = neighbor.direction
                        }
                    } else {
                        minNeighbor = neighbor.value
                        minDirection = neighbor.direction
                    }
                }
            }
        }
        
        if let minNeighbor = minNeighbor, let minDirection = minDirection {
            print("SEARCHING MINIMUM NEIGHBOR: \(position) \(direction.rawValue) IS: \(minNeighbor) [\(minDirection.rawValue)]")
        } else {
            print("SEARCHING MINIMUM NEIGHBOR: \(position) \(direction.rawValue) NOT FOUND")
        }
        
        return (value: minNeighbor, direction: minDirection, total: totalNeighbors)
    }
    
    public func describe() {
        self.maze.describe(position: position, visited: visited, stack: stack)
        print("MOVEMENTS: \(movements.map({ ($0.rawIndex, $0.direction.rawValue) }))")
        print("STACK: \(stack)")
        print("VISITED: \(visited)")
        self.matrix.describe()
    }
    
}


