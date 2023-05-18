//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 17/05/23.
//

import Foundation

public enum FloodFillAgentOrientation: String {
    case north = "NORTH"
    case south = "SOUTH"
    case east = "EAST"
    case west = "WEST"
}

public enum FloodFillAgentDirection: String {
    case left = "LEFT"
    case right = "RIGHT"
    case up = "UP"
    case down = "DOWN"
}

public struct FloodFillAgent {
    
    var debug: Bool = true
    
    public var name: String = "default"
    
    public var position: (row: Int, column: Int) = (0, 0)
    
    public var positionLeft: (row: Int, column: Int)? {
        switch orientation {
        case .north:
            if position.column == firstColumn {
                return nil
            }
            return (position.row, position.column - 1)
        case .south:
            if position.column == lastColumn {
                return nil
            }
            return (position.row, position.column + 1)
        case .east:
            if position.row == firstRow {
                return nil
            }
            return (position.row - 1, position.column)
        case .west:
            if position.row == lastRow {
                return nil
            }
            return (position.row + 1, position.column)
        }
    }
    
    public var positionRight: (row: Int, column: Int)? {
        switch orientation {
        case .north:
            if position.column == lastColumn {
                return nil
            }
            return (position.row, position.column + 1)
        case .south:
            if position.column == firstColumn {
                return nil
            }
            return (position.row, position.column - 1)
        case .east:
            if position.row == lastRow {
                return nil
            }
            return (position.row + 1, position.column)
        case .west:
            if position.row == firstRow {
                return nil
            }
            return (position.row - 1, position.column)
        }
    }
    
    public var positionUp: (row: Int, column: Int)? {
        switch orientation {
        case .north:
            if position.row == firstRow {
                return nil
            }
            return (position.row - 1, position.column)
        case .south:
            if position.row == lastRow {
                return nil
            }
            return (position.row + 1, position.column)
        case .east:
            if position.column == lastColumn {
                return nil
            }
            return (position.row, position.column + 1)
        case .west:
            if position.column == firstColumn {
                return nil
            }
            return (position.row, position.column - 1)
        }
    }
    
    public var positionDown: (row: Int, column: Int)? {
        switch orientation {
        case .north:
            if position.row == lastRow {
                return nil
            }
            return (position.row + 1, position.column)
        case .south:
            if position.row == firstRow {
                return nil
            }
            return (position.row - 1, position.column)
        case .east:
            if position.column == firstColumn {
                return nil
            }
            return (position.row, position.column - 1)
        case .west:
            if position.column == lastColumn {
                return nil
            }
            return (position.row, position.column + 1)
        }
    }
    
    public var rows: Int {
        matrix.count
    }
    
    public var columns: Int {
        matrix.first?.count ?? 0
    }
    
    public var firstColumn: Int {
        0
    }
    
    public var firstRow: Int {
        0
    }
    
    public var lastColumn: Int {
        columns - 1
    }
    
    public var lastRow: Int {
        rows - 1
    }
    
    public var index: Int {
        getIndex(position: position)
    }
    
    public var indexLeft: Int? {
        guard let positionLeft = positionLeft else { return nil }
        return getIndex(position: positionLeft)
    }
    
    public var indexRight: Int? {
        guard let positionRight = positionRight else { return nil }
        return getIndex(position: positionRight)
    }
    
    public var indexUp: Int? {
        guard let positionUp = positionUp else { return nil }
        return getIndex(position: positionUp)
    }
    
    public var indexDown: Int? {
        guard let positionDown = positionDown else { return nil }
        return getIndex(position: positionDown)
    }
    
    public var orientation: FloodFillAgentOrientation = .south
    
    public var matrix: [[Int]]
    
    public var walls: [(Int, Int)]
    
    public var stack: [Int] = []

    public var visited: [Int] = []
    
    public var backStack: [Int] = []
    
    public init(debug: Bool = true, name: String = "default", position: (row: Int, column: Int) = (0, 0), orientation: FloodFillAgentOrientation = .south, matrix: [[Int]] = [[-1, -1],[-1, -1]], walls: [(Int, Int)] = [], stack: [Int] = [], visited: [Int] = [], backStack: [Int] = []) {
        
        var initialMatrix = matrix
        
        if initialMatrix[position.row][position.column] == -1 {
            initialMatrix[position.row][position.column] = 0
        }
        
        self.debug = debug
        self.name = name
        self.position = position
        self.orientation = orientation
        self.matrix = initialMatrix
        self.walls = walls
        self.stack = stack
        self.visited = visited
        self.backStack = backStack
    }
    
    public func log(_ message: String) {
        if debug {
            print("[\(name)] \(Date().formatted()): \(message)")
        }
    }
    
    public func describe() {
        print("Flood-Fill Agent: \(name)")
        print("| row: \(position.row) column: \(position.column)")
        print("| orientation: \(orientation.rawValue)")
        printMatrix(matrix: matrix, walls: walls, stack: stack, visited: visited, position: position)
    }
    
    public func verifyWalls(walls: [(Int, Int)]) -> (verified: Bool, index: (Int, Int)?) {
        for (i, j) in walls {
            guard let _ = walls.first(where: { $0 == j && $1 == i})
            else { return (false, (i, j)) }
        }
        return (true, nil)
    }
    
    public func printMatrix(matrix: [[Int]], walls: [(Int, Int)], stack: [Int], visited: [Int], position: (row: Int, column: Int)) {
        for i in 0..<matrix.count {
            
            let row = matrix[i]
            
            // TOP
            for j in 0..<row.count {
                let index = i * row.count + j
                let indexUp = (i - 1) * row.count + j
                let indexLeft = i * row.count + (j - 1)
                let indexRight = i * row.count + (j + 1)
                
                var left = false
                
                // LEFT
                if let _ = walls.first(where: { $0 == index && $1 == indexLeft }) {
                    left = true
                }
                if j == 0 {
                    left = true
                }
                
                var right = false
                
                // RIGHT
                if let _ = walls.first(where: { $0 == index && $1 == indexRight }) {
                    right = true
                }
                if j == row.count - 1 {
                    right = true
                }
                
                if let _ = walls.first(where: { $0 == index && $1 == indexUp }) {
                    print("\(left ? "|" : "=")===\(right ? "|" : "=")", terminator: "")
                } else {
                    if indexUp < 0 {
                        print("\(left ? "+" : "=")===\(right ? "+" : "=")", terminator: "")
                    } else {
                        print("\(left ? "|" : " ")   \(right ? "|" : " ")", terminator: "")
                    }
                }
            }
            print()
            
            for j in 0..<row.count {
                
                let value = row[j]
                
                let index = i * row.count + j
                let indexLeft = i * row.count + (j - 1)
                let indexRight = i * row.count + (j + 1)
                
                var left = " "
                
                // LEFT
                if let _ = walls.first(where: { $0 == index && $1 == indexLeft }) {
                    left = "|"
                }
                if j == 0 {
                    left = "|"
                }
                
                var right = " "
                
                // RIGHT
                if let _ = walls.first(where: { $0 == index && $1 == indexRight }) {
                    right = "|"
                }
                if j == row.count - 1 {
                    right = "|"
                }
                
                var symbol = " \(value < 0 ? "*" : "\(value)") "
                
                var isStacked = false
                var isVisited = false
                
                if let _ = stack.first(where: { $0 == index }) {
                    isStacked = true
                }
                
                if let _ = visited.first(where: { $0 == index }) {
                    isVisited = true
                }
                
                if position.row == i && position.column == j {
                    symbol = "<\(value < 0 ? "*" : "\(value)")>"
                } else {
                    if isStacked {
                        if isVisited {
                            symbol = "{\(value < 0 ? "*" : "\(value)")}"
                        } else {
                            symbol = "[\(value < 0 ? "*" : "\(value)")]"
                        }
                    } else {
                        if isVisited {
                            symbol = "(\(value < 0 ? "*" : "\(value)"))"
                        }
                    }
                }
                
                print("\(left)\(symbol)\(right)", terminator: "")
                
            }
            print()
            
        }
        
        // DOWN
        for j in 0..<matrix.first!.count {
            print("\(j == 0 ? "+" : "=")===\(j == matrix.first!.count - 1 ? "+" : "=")", terminator: "")
        }
        print()
    }
    
    public func getIndex(position: (row: Int, column: Int)) -> Int {
        return position.row * columns + position.column
    }
    
    public func getPosition(index: Int) -> (row: Int, column: Int) {
        let row = Int(index / columns)
        let column = index % columns
        return (row, column)
    }
    
    public func getMatrixValue(on position: (row: Int, column: Int)) -> Int {
        return matrix[position.row][position.column]
    }
    
    public func getMatrixValue(at index: Int) -> Int {
        return getMatrixValue(on: getPosition(index: index))
    }
    
    public mutating func setMatrixValue(_ value: Int, on position: (row: Int, column: Int)) {
        matrix[position.row][position.column] = value
    }
    
    public mutating func setMatrixValue(_ value: Int, at index: Int) {
        setMatrixValue(value, on: getPosition(index: index))
    }
    
    public mutating func scan() {
        log("Scanning... \(position) <<\(index)>> [\(orientation.rawValue)]")
        
        let value = getMatrixValue(on: position)
        
        if let indexLeft = indexLeft {
            if !walls.contains(where: { $0.0 == index && $0.1 == indexLeft }) && !visited.contains(where: {$0 == indexLeft}) {
                stack.append(indexLeft)
                setMatrixValue(value + 1, at: indexLeft)
            }
        }
        
        if let indexUp = indexUp {
            if !walls.contains(where: { $0.0 == index && $0.1 == indexUp }) &&  !visited.contains(where: {$0 == indexUp}) {
                stack.append(indexUp)
                setMatrixValue(value + 1, at: indexUp)
            }
        }
        
        if let indexRight = indexRight {
            if !walls.contains(where: { $0.0 == index && $0.1 == indexRight }) &&  !visited.contains(where: {$0 == indexRight}) {
                stack.append(indexRight)
                setMatrixValue(value + 1, at: indexRight)
            }
        }
        
        if let indexDown = indexDown {
            if !walls.contains(where: { $0.0 == index && $0.1 == indexDown }) &&  !visited.contains(where: {$0 == indexDown}) {
                stack.append(indexDown)
                setMatrixValue(value + 1, at: indexDown)
            }
        }
    }
    
    public func searchLowest() -> Int? {
        log("Searching lowest: \(position) <<\(index)>> [\(orientation.rawValue)]")
        
        var lowestIndex: Int?
        var lowestValue = Int.max
        
        for index in stack {
            let value = getMatrixValue(at: index)
            if value < 0 { continue }
            if value < lowestValue {
                lowestIndex = index
                lowestValue = value
            }
        }
        
        log("-> \(lowestIndex ?? -1)")
        
        return lowestIndex
    }
    
    public func seachLowestDirection() -> FloodFillAgentDirection? {
        log("Searching lowest direction: \(position) <<\(index)>> [\(orientation.rawValue)]")
        
        var direction: FloodFillAgentDirection = .down
        var directionValue: Int = Int.max
        
        if let indexLeft = indexLeft {
            let value = getMatrixValue(at: indexLeft)
            if !walls.contains(where: { $0.0 == index && $0.1 == indexLeft }) && value >= 0 && value < directionValue {
                directionValue = value
                switch orientation {
                case .north:
                    direction = .left
                case .south:
                    direction = .right
                case .east:
                    direction = .up
                case .west:
                    direction = .down
                }
            }
        }
        
        if let indexUp = indexUp {
            let value = getMatrixValue(at: indexUp)
            if !walls.contains(where: { $0.0 == index && $0.1 == indexUp }) && value >= 0 && value < directionValue {
                directionValue = value
                switch orientation {
                case .north:
                    direction = .up
                case .south:
                    direction = .down
                case .east:
                    direction = .right
                case .west:
                    direction = .left
                }
            }
        }
        
        if let indexRight = indexRight {
            let value = getMatrixValue(at: indexRight)
            if !walls.contains(where: { $0.0 == index && $0.1 == indexRight }) && value >= 0 && value < directionValue {
                directionValue = value
                switch orientation {
                case .north:
                    direction = .right
                case .south:
                    direction = .left
                case .east:
                    direction = .down
                case .west:
                    direction = .up
                }
            }
        }
        
        if let indexDown = indexDown {
            let value = getMatrixValue(at: indexDown)
            if !walls.contains(where: { $0.0 == index && $0.1 == indexDown }) && value >= 0 && value < directionValue {
                directionValue = value
                switch orientation {
                case .north:
                    direction = .down
                case .south:
                    direction = .up
                case .east:
                    direction = .left
                case .west:
                    direction = .right
                }
            }
        }
        
        log("-> \(direction.rawValue)")
        
        return direction
    }
    
    public mutating func turnLeft() {
        log("TURN LEFT \(orientation.rawValue)")
        switch orientation {
        case .north:
            orientation = .west
        case .west:
            orientation = .south
        case .south:
            orientation = .east
        case .east:
            orientation = .north
        }
        log("-> \(orientation.rawValue)")
    }
    
    public mutating func turnRight() {
        log("TURN RIGHT \(orientation.rawValue)")
        switch orientation {
        case .north:
            orientation = .east
        case .east:
            orientation = .south
        case .south:
            orientation = .west
        case .west:
            orientation = .north
        }
        log("-> \(orientation.rawValue)")
    }
    
    public mutating func turn(direction: FloodFillAgentDirection) {
        log("Turning until direction: \(direction.rawValue) [\(orientation.rawValue)]")
        
        switch direction {
        case .left:
            switch orientation {
            case .north:
                turnLeft()
            case .west:
                log("Not necessary turn")
            case .east:
                turnLeft()
                turnLeft()
            case .south:
                turnRight()
            }
        case .right:
            switch orientation {
            case .north:
                turnRight()
            case .west:
                turnRight()
                turnRight()
            case .east:
                log("Not necessary turn")
            case .south:
                turnLeft()
            }
        case .up:
            switch orientation {
            case .north:
                log("Not necessary turn")
            case .west:
                turnRight()
            case .east:
                turnLeft()
            case .south:
                turnLeft()
                turnLeft()
            }
        case .down:
            switch orientation {
            case .north:
                turnLeft()
                turnLeft()
            case .west:
                turnLeft()
            case .east:
                turnRight()
            case .south:
                log("Not necessary turn")
            }
        }
        
        log("New turning direction: \(direction.rawValue) [\(orientation.rawValue)]")
    }
    
    public mutating func goForward() {
        log("FORWARD")
        if let positionUp = positionUp {
            log("Forwarding from \(position) <<\(index)>> to \(positionUp) <<\(getIndex(position: positionUp))>>")
            position = positionUp
        } else {
            log("ERROR MOVING FORWADING ON \(position) <<\(index)>> [\(orientation.rawValue)]")
        }
    }
    
    public mutating func goBack(initial: Bool = false) {
        log("Go back from \(position) <<\(index)>> [\(initial ? "initial" : "continue")]")
        
        if initial {
            backStack = []
        }
        
        if index == 0 {
            log("Robot is in origin")
            return
        }
        
        log("Going back to origin from \(position) <<\(index)>>")
        
        backStack.append(index)
        
        if let lowestDirection = seachLowestDirection() {
            turn(direction: lowestDirection)
            goForward()
            goBack()
        }
    }
    
    public func clone() -> FloodFillAgent {
        log("Clonning robot: \(name) - clon")
        return FloodFillAgent(
            debug: debug,
            name: "\(name) - clon",
            position: position,
            orientation: orientation,
            matrix: matrix,
            walls: walls,
            stack: stack,
            visited: visited
        )
    }
    
    public func pathTo(position otherPosition: (row: Int, column: Int)) -> [Int] {
        log("Finding path between \(position) <<\(index)>> => \(otherPosition) <<\(getIndex(position: otherPosition))>>")
        
        var robotClonned = clone()
        
        robotClonned.position = otherPosition
        robotClonned.goBack(initial: true)
        
        var path = robotClonned.backStack
        
        //path.append(0)
        path.reverse()
        
        
        log("Path: \(path)")
        
        return path
    }
    
    public mutating func goTo(postion otherPosition: (row: Int, column: Int)) {
        log("Go to: \(otherPosition) <<\(getIndex(position: otherPosition))>>")
        
        goBack(initial: true)
        
        let path = pathTo(position: otherPosition)
        
        for indexPath in path {
            if indexLeft == indexPath {
                log("Index Left \(indexPath) [\(orientation.rawValue)]")
                switch orientation {
                case .north:
                    turn(direction: .left)
                case .south:
                    turn(direction: .right)
                case .east:
                    turn(direction: .up)
                case .west:
                    turn(direction: .down)
                }
                goForward()
            } else if indexRight == indexPath {
                log("Index Right \(indexPath) [\(orientation.rawValue)]")
                switch orientation {
                case .north:
                    turn(direction: .right)
                case .south:
                    turn(direction: .left)
                case .east:
                    turn(direction: .down)
                case .west:
                    turn(direction: .up)
                }
                goForward()
            } else if indexUp == indexPath {
                log("Index Up \(indexPath) [\(orientation.rawValue)]")
                switch orientation {
                case .north:
                    turn(direction: .up)
                case .south:
                    turn(direction: .down)
                case .east:
                    turn(direction: .right)
                case .west:
                    turn(direction: .left)
                }
                goForward()
            } else if indexDown == indexPath {
                log("Index Down \(indexPath) [\(orientation.rawValue)]")
                switch orientation {
                case .north:
                    turn(direction: .down)
                case .south:
                    turn(direction: .up)
                case .east:
                    turn(direction: .left)
                case .west:
                    turn(direction: .right)
                }
                goForward()
            }
        }
    }
    
    public mutating func next() {
        log("Next")
        
        log("Index: \(index) Position: \(position)")
        
        log("Stack/1: \(stack)")
        
        stack = stack.filter({ $0 != index })
        
        visited.append(index)
        
        log("Visited: \(visited)")
        
        scan()
        
        if let lowestIndex = searchLowest() {
            goTo(postion: getPosition(index: lowestIndex))
        }
        
        log("Stack/2: \(stack)")
    }
    
    public mutating func goToGoal(at goalIndex: Int, withDescription description: Bool = true) -> [Int] {
        if description {
            describe()
        }
        
        if index == goalIndex {
            log("GOAL!!!")
            var robotClonned = clone()
            
            robotClonned.position = position
            robotClonned.goBack(initial: true)
            
            var path = robotClonned.backStack
            
            path.append(0)
            path.reverse()
            log("PATH: \(path)")
            return path
        }
        
        next()
        
        return goToGoal(at: goalIndex, withDescription: description)
    }
    
    public mutating func goToGoal(on position: (row: Int, column: Int), withDescription description: Bool = true) -> [Int] {
        return goToGoal(at: getIndex(position: position), withDescription: description)
    }
}
