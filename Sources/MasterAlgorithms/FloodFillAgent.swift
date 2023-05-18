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
    
    public var position: MatrixIndex = (0, 0)
    
    public var positionLeft: MatrixIndex? {
        switch orientation {
        case .north:
            return matrix.selectIndex(at: position, direction: .left)
        case .south:
            return matrix.selectIndex(at: position, direction: .right)
        case .east:
            return matrix.selectIndex(at: position, direction: .up)
        case .west:
            return matrix.selectIndex(at: position, direction: .down)
        }
    }
    
    public var positionRight: MatrixIndex? {
        switch orientation {
        case .north:
            return matrix.selectIndex(at: position, direction: .right)
        case .south:
            return matrix.selectIndex(at: position, direction: .left)
        case .east:
            return matrix.selectIndex(at: position, direction: .down)
        case .west:
            return matrix.selectIndex(at: position, direction: .up)
        }
    }
    
    public var positionUp: MatrixIndex? {
        switch orientation {
        case .north:
            return matrix.selectIndex(at: position, direction: .up)
        case .south:
            return matrix.selectIndex(at: position, direction: .down)
        case .east:
            return matrix.selectIndex(at: position, direction: .right)
        case .west:
            return matrix.selectIndex(at: position, direction: .left)
        }
    }
    
    public var positionDown: MatrixIndex? {
        switch orientation {
        case .north:
            return matrix.selectIndex(at: position, direction: .down)
        case .south:
            return matrix.selectIndex(at: position, direction: .up)
        case .east:
            return matrix.selectIndex(at: position, direction: .left)
        case .west:
            return matrix.selectIndex(at: position, direction: .right)
        }
    }
    
    public var index: RawIndex? {
        matrix.getRawIndex(at: position)
    }
    
    public var indexLeft: RawIndex? {
        guard let positionLeft = positionLeft else { return nil }
        return matrix.getRawIndex(at: positionLeft)
    }
    
    public var indexRight: RawIndex? {
        guard let positionRight = positionRight else { return nil }
        return matrix.getRawIndex(at: positionRight)
    }
    
    public var indexUp: RawIndex? {
        guard let positionUp = positionUp else { return nil }
        return matrix.getRawIndex(at: positionUp)
    }
    
    public var indexDown: RawIndex? {
        guard let positionDown = positionDown else { return nil }
        return matrix.getRawIndex(at: positionDown)
    }
    
    public var orientation: FloodFillAgentOrientation = .south
    
    public var matrix: Matrix
    
    public var walls: [(indexA: RawIndex, indexB: RawIndex)]
    
    public var stack: [Int] = []

    public var visited: [Int] = []
    
    public var backStack: [Int] = []
    
    public var metrics: [String:Int] = [:]
    
    public init(debug: Bool = true, name: String = "default", position: MatrixIndex = (0, 0), orientation: FloodFillAgentOrientation = .south, matrix: Matrix = Matrix.squared(2), walls: [(Int, Int)] = [], stack: [Int] = [], visited: [Int] = [], backStack: [Int] = [], metrics: [String:Int] = [:]) {
        
        var initialMatrix = matrix
        
        if initialMatrix.getValue(at: position) == -1 {
            initialMatrix.setValue(0, at: position)
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
        self.metrics = metrics
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
        print("| metrics: \(metrics)")
        printMatrix(matrix: matrix, walls: walls, stack: stack, visited: visited, position: position)
    }
    
    public func verifyWalls(walls: [(Int, Int)]) -> (verified: Bool, index: (Int, Int)?) {
        for (i, j) in walls {
            guard let _ = walls.first(where: { $0 == j && $1 == i})
            else { return (false, (i, j)) }
        }
        return (true, nil)
    }
    
    public func printMatrix(matrix: Matrix, walls: [(Int, Int)], stack: [Int], visited: [Int], position: MatrixIndex) {
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
    
    public mutating func scan() {
        log("Scanning... \(position) <<\(index ?? -1)>> [\(orientation.rawValue)]")
        
        guard let value = matrix.getValue(at: position)
        else { return }
        
        if let count = metrics["scans"] {
            metrics.updateValue(count + 1, forKey: "scans")
        } else {
            metrics["scans"] = 1
        }
        
        if let indexLeft = indexLeft {
            if !walls.contains(where: { $0.indexA == index && $0.indexB == indexLeft }) && !visited.contains(where: {$0 == indexLeft}) {
                stack.append(indexLeft)
                matrix.setValue(value + 1, from: indexLeft)
            }
        }
        
        if let indexUp = indexUp {
            if !walls.contains(where: { $0.indexA == index && $0.indexB == indexUp }) &&  !visited.contains(where: {$0 == indexUp}) {
                stack.append(indexUp)
                matrix.setValue(value + 1, from: indexUp)
            }
        }
        
        if let indexRight = indexRight {
            if !walls.contains(where: { $0.indexA == index && $0.indexB == indexRight }) &&  !visited.contains(where: {$0 == indexRight}) {
                stack.append(indexRight)
                matrix.setValue(value + 1, from: indexRight)
            }
        }
        
        if let indexDown = indexDown {
            if !walls.contains(where: { $0.indexA == index && $0.indexB == indexDown }) &&  !visited.contains(where: {$0 == indexDown}) {
                stack.append(indexDown)
                matrix.setValue(value + 1, from: indexDown)
            }
        }
    }
    
    public func searchLowest() -> Int? {
        log("Searching lowest: \(position) <<\(index ?? -1)>> [\(orientation.rawValue)]")
        
        var lowestIndex: Int?
        var lowestValue = Int.max
        
        for index in stack {
            guard let value = matrix.getValue(from: index)
            else { continue }
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
        log("Searching lowest direction: \(position) <<\(index ?? -1)>> [\(orientation.rawValue)]")
        
        var direction: FloodFillAgentDirection = .down
        var directionValue: Int = Int.max
        
        if let indexLeft = indexLeft {
            if let value = matrix.getValue(from: indexLeft) {
                if !walls.contains(where: { $0.indexA == index && $0.indexB == indexLeft }) && value >= 0 && value < directionValue {
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
        }
        
        if let indexUp = indexUp {
            if let value = matrix.getValue(from: indexUp) {
                if !walls.contains(where: { $0.indexA == index && $0.indexB == indexUp }) && value >= 0 && value < directionValue {
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
        }
        
        if let indexRight = indexRight {
            if let value = matrix.getValue(from: indexRight) {
                if !walls.contains(where: { $0.indexA == index && $0.indexB == indexRight }) && value >= 0 && value < directionValue {
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
        }
        
        if let indexDown = indexDown {
            if let value = matrix.getValue(from: indexDown) {
                if !walls.contains(where: { $0.indexA == index && $0.indexB == indexDown }) && value >= 0 && value < directionValue {
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
        
        if let count = metrics["turnLeft"] {
            metrics.updateValue(count + 1, forKey: "turnLeft")
        } else {
            metrics["turnLeft"] = 1
        }
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
        
        if let count = metrics["turnRight"] {
            metrics.updateValue(count + 1, forKey: "turnRight")
        } else {
            metrics["turnRight"] = 1
        }
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
            log("Forwarding from \(position) <<\(index ?? -1)>> to \(positionUp) <<\(matrix.getRawIndex(at: positionUp) ?? -1)>>")
            position = positionUp
        } else {
            log("ERROR MOVING FORWADING ON \(position) <<\(index ?? -1)>> [\(orientation.rawValue)]")
        }
        
        if let count = metrics["forwards"] {
            metrics.updateValue(count + 1, forKey: "forwards")
        } else {
            metrics["forwards"] = 1
        }
    }
    
    public mutating func goBack(initial: Bool = false) {
        log("Go back from \(position) <<\(index ?? -1)>> [\(initial ? "initial" : "continue")]")
        
        if initial {
            backStack = []
        }
        
        guard let index = index else { return }
        
        if index == matrix.firstRawIndex {
            log("Agent is in origin")
            return
        }
        
        log("Going back to origin from \(position) <<\(index)>>")
        
        backStack.append(index)
        
        if let count = metrics["seachLowestDirection"] {
            metrics.updateValue(count + 1, forKey: "seachLowestDirection")
        } else {
            metrics["seachLowestDirection"] = 1
        }
        
        if let lowestDirection = seachLowestDirection() {
            turn(direction: lowestDirection)
            goForward()
            goBack()
        }
    }
    
    public func clone() -> FloodFillAgent {
        log("Clonning agent: \(name) - clon")
        return FloodFillAgent(
            debug: debug,
            name: "\(name) - clon",
            position: position,
            orientation: orientation,
            matrix: matrix,
            walls: walls,
            stack: stack,
            visited: visited,
            metrics: [:]
        )
    }
    
    public func pathTo(position otherPosition: MatrixIndex) -> (path: RawIndexPath, metrics: [String:Int]) {
        log("Finding path between \(position) <<\(index ?? -1)>> => \(otherPosition) <<\(matrix.getRawIndex(at: otherPosition) ?? -1)>>")
        
        var agentClonned = clone()
        
        agentClonned.position = otherPosition
        agentClonned.goBack(initial: true)
        
        var path = agentClonned.backStack
        
        //path.append(0)
        path.reverse()
        
        log("Path: \(path)")
        
        return (path, agentClonned.metrics)
    }
    
    public mutating func goTo(postion otherPosition: MatrixIndex) {
        log("Go to: \(otherPosition) <<\(matrix.getRawIndex(at: otherPosition) ?? -1)>>")
        
        goBack(initial: true)
        
        let (path, clonMetrics) = pathTo(position: otherPosition)
        
        if let count = metrics["backwards"] {
            if let forwards = clonMetrics["forwards"] {
                metrics.updateValue(count + forwards, forKey: "backwards")
            }
        } else {
            if let forwards = clonMetrics["forwards"] {
                metrics.updateValue(forwards, forKey: "backwards")
            }
        }
        
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
        guard let index = index else { return }
        
        log("Next")
        
        log("Index: \(index) Position: \(position)")
        
        log("Stack/1: \(stack)")
        
        stack = stack.filter({ $0 != index })
        
        visited.append(index)
        
        log("Visited: \(visited)")
        
        scan()
        
        if let count = metrics["searchLowest"] {
            metrics.updateValue(count + 1, forKey: "searchLowest")
        } else {
            metrics["searchLowest"] = 1
        }
        
        if let lowestIndex = searchLowest() {
            if let position = matrix.getIndex(from: lowestIndex) {
                goTo(postion: position)
            }
        }
        
        log("Stack/2: \(stack)")
    }
    
    public mutating func goToGoal(from goalIndex: Int, withDescription description: Bool = true) -> RawIndexPath {
        if description {
            describe()
        }
        
        if let count = metrics["goals"] {
            metrics.updateValue(count + 1, forKey: "goals")
        } else {
            metrics["goals"] = 1
        }
        
        if index == goalIndex {
            log("GOAL!!!")
            var agentClonned = clone()
            
            agentClonned.position = position
            agentClonned.goBack(initial: true)
            
            var path = agentClonned.backStack
            
            path.append(0)
            path.reverse()
            log("PATH: \(path)")
            return path
        }
        
        next()
        
        if stack.isEmpty {
            log("ERROR: NOT RECHEABLE")
            var agentClonned = clone()
            
            agentClonned.position = position
            agentClonned.goBack(initial: true)
            
            var path = agentClonned.backStack
            
            path.append(0)
            path.reverse()
            log("PATH: \(path)")
            return path
        }
        
        return goToGoal(from: goalIndex, withDescription: description)
    }
    
    public mutating func goToGoal(at position: MatrixIndex, withDescription description: Bool = true) -> RawIndexPath {
        guard let index = matrix.getRawIndex(at: position) else { return [] }
        
        return goToGoal(from: index, withDescription: description)
    }
}
