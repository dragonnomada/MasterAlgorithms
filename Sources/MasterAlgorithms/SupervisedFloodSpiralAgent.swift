//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 29/05/23.
//

import Foundation

public enum SupervisedState: String {
    case idle = "IDLE"
    case buffering = "BUFFERING"
}

public struct SupervisedFloodSpiralAgent {
    
    static func encode(withDirection direction: MatrixDirection) -> String {
        switch direction {
        case .left:
            return "L"
        case .right:
            return "R"
        case .up:
            return "U"
        case .down:
            return "D"
        }
    }
    
    static func encode(withScans scans: [FloodSpiralOperation]) -> String {
        var operations = scans
        
        let a = operations[0]
        operations[0] = operations[2]
        operations[2] = a
        
        var encoded = ""
        
        for operation in operations {
            switch operation {
            case .idle:
                encoded += "I"
            case .forward:
                encoded += "F"
            case .turnLeft:
                encoded += "L"
            case .turnRight:
                encoded += "R"
            case .scanWall:
                encoded += "1"
            case .scanEmpty:
                encoded += "0"
            }
        }
        
        return encoded
    }
    
    static func encode(withOperations operations: [FloodSpiralOperation]) -> String {
        var encoded = ""
        
        for operation in operations {
            switch operation {
            case .idle:
                encoded += "I"
            case .forward:
                encoded += "F"
//                return encoded
            case .turnLeft:
                encoded += "L"
            case .turnRight:
                encoded += "R"
            case .scanWall:
                encoded += "W"
            case .scanEmpty:
                encoded += "X"
            }
        }
        return encoded
    }
    
    public var agent: FloodSpiralAgent
    
    public var debug: Bool {
        get {
            agent.debug
        }
        set {
            agent.debug = newValue
        }
    }
    
    public var expirence: [String: [(count: Int, chain: String)]] = [:]
    
    public var knowledge: [String: [String]] = [:]
    public var knowledgeSample: [String: [String]] = [:]
    
    public var knowledgeRatio: Int = 100
    public var knowledgeDeepSort: Int = 2
    
    public init(maze: [[Int]], position: MatrixIndex = (row: 0, column: 0), direction: MatrixDirection = .right) {
        self.agent = FloodSpiralAgent(maze: maze, position: position)
        self.agent.turnAlign(direction: direction)
        self.agent.resetOperations()
    }
    
    public mutating func reset(maze: [[Int]], position: MatrixIndex = (row: 0, column: 0), direction: MatrixDirection = .right) {
        self.agent = FloodSpiralAgent(maze: maze, position: position)
        self.agent.turnAlign(direction: direction)
        self.agent.resetOperations()
    }
    
    public mutating func track() -> [String] {
        var stack: [String] = []
        
        //print(self.agent.operations.map({ ($0.operation.rawValue, $0.direction.rawValue) }))
        
        var memory: [FloodSpiralOperationRecord] = []
        var buffers: [[FloodSpiralOperationRecord]] = []
        var lastBuffer: [FloodSpiralOperationRecord] = []
        
        //var state: SupervisedState = .buffering
        
        for (operation, direction, spiralValue) in agent.operations {
            memory.append((operation, direction, spiralValue))
            
            if memory.count > 8 {
                let _ = memory.removeFirst()
            }
            
            /*if operation == .scanEmpty || operation == .scanWall {
                state = .idle
            }*/
            
            /*if state == .buffering {
                lastBuffer.append((operation, direction, spiralValue))
            }*/
            
            lastBuffer.append((operation, direction, spiralValue))
            
            if memory.count == 8 {
                let q0 = memory[0].direction == .right && (memory[0].operation == .scanEmpty || memory[0].operation == .scanWall)
                let q1 = memory[1].direction == .up && memory[1].operation == .turnLeft
                let q2 = memory[2].direction == .up && (memory[2].operation == .scanEmpty || memory[2].operation == .scanWall)
                let q3 = memory[3].direction == .left && memory[3].operation == .turnLeft
                let q4 = memory[4].direction == .left && (memory[4].operation == .scanEmpty || memory[4].operation == .scanWall)
                let q5 = memory[5].direction == .down && memory[5].operation == .turnLeft
                let q6 = memory[6].direction == .down && (memory[6].operation == .scanEmpty || memory[6].operation == .scanWall)
                let q7 = memory[7].direction == .right && memory[7].operation == .turnLeft
                
                if q0 && q1 && q2 && q3 && q4 && q5 && q6 && q7 {
                    //state = .buffering
                    
                    //var buffer = lastBuffer
                    
                    //buffer.append(contentsOf: memory)
                    
                    //buffers.append(buffer)
                    buffers.append(lastBuffer)
                    lastBuffer = []
                }
            }
        }
        
        /*if lastBuffer.count > 0 {
            buffers.append(lastBuffer)
        }*/
        
        var first = true
        
        var line = ""
        
        var key = ""
        var chain = ""
        
        for buffer in buffers {
            //print(buffer.map({"[\($0.spiralValue)] \($0.operation) -> \($0.direction)"}))
            //print(SupervisedFloodSpiralAgent.encode(withOperations: buffer.map({$0.operation})))
            //print(buffer.map({"\($0.operation.rawValue)"}))
            
            let bufferLeft = buffer.dropLast(8)
            let scans = buffer.dropFirst(buffer.count - 8).filter({$0.operation == .scanEmpty || $0.operation == .scanWall})
            //let bufferRight = buffer.dropFirst(buffer.count - 7).filter({$0.operation == .turnLeft})
            
            /*print(SupervisedFloodSpiralAgent.encode(withOperations: bufferLeft.map({$0.operation})), terminator: " ")
            print(SupervisedFloodSpiralAgent.encode(withScans: scans.map({$0.operation})), terminator: " ")
            print(SupervisedFloodSpiralAgent.encode(withOperations: bufferRight.map({$0.operation})))*/
            
            //print(SupervisedFloodSpiralAgent.encode(withDirection: buffer.first!.direction), terminator: "")
            if !first {
                //print(SupervisedFloodSpiralAgent.encode(withOperations: bufferLeft.map({$0.operation})))
                chain = SupervisedFloodSpiralAgent.encode(withOperations: bufferLeft.map({$0.operation}))
                line += chain
                if expirence.keys.contains(key) {
                    expirence[key]?.append((stack.count, chain))
                } else {
                    expirence[key] = [(stack.count, chain)]
                }
                stack.append(line)
                line = ""
            }
            //print(SupervisedFloodSpiralAgent.encode(withScans: scans.map({$0.operation})), terminator: " ")
            key = SupervisedFloodSpiralAgent.encode(withScans: scans.map({$0.operation}))
            line += key
            line += " "
            
            first = false
        }
        
        /*if lastBuffer.count > 0 {
            //print(SupervisedFloodSpiralAgent.encode(withOperations: lastBuffer.map({$0.operation})))
            line += SupervisedFloodSpiralAgent.encode(withOperations: lastBuffer.map({$0.operation}))
        } else {
            //print("X")
            line += "X"
        }
        
        if !line.isEmpty {
            stack.append(line)
        }*/
        
        return stack
    }
    
    public mutating func generateKnowledge(keepAll: Bool = true, withSample: Bool = false) {
        for key in self.expirence.keys {
//            let chains = self.expirence[key]!.sorted(by: { (arg0, arg1) in
//                let (count1, chain1) = arg0
//                let (count2, chain2) = arg1
//
//                if count1 == count2 {
//                    return chain1 < chain2
//                }
//
//                return count1 < count2
//            })
        
            let chains = self.expirence[key]!
            
            let maxCount = chains.map({ $0.count }).max()!
            
            let chainsTransform = chains.map({ (count, chain) in
                var chains: [String] = []
                for _ in 0..<(maxCount + 1 - count) {
                    chains.append(chain)
                }
                return chains
            }).flatMap({$0}).sorted()
            
//            let countTransform = chains.map({ (count, chain) in
//                var counts: [Int] = []
//                for _ in 0..<(maxCount + 1 - count) {
//                    counts.append(count)
//                }
//                return counts
//            })
            
            if keepAll {
                knowledge[key] = chainsTransform
            }
            
            if withSample {
//                var sample: [String] = chainsTransform
//
//                for _ in 0...knowledgeDeepSort {
//                    sample.sort(by: {_,_ in Bool.random()})
//                }
//
//                let h = min(sample.count, knowledgeRatio)
//                let k = sample.count - h
//
//                sample.removeLast(k)
                
                var sample: [String] = []
                var chainsTransformCopy = chainsTransform
                
                for _ in 0..<knowledgeRatio {
                    let index = Int.random(in: 0..<chainsTransformCopy.count)
                    let item = chainsTransformCopy[index]
                    chainsTransformCopy.remove(at: index)
                    sample.append(item)
                }
                
                knowledgeSample[key] = sample
            }
        }
    }
    
}
