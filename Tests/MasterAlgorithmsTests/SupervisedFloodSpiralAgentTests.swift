//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 29/05/23.
//

import XCTest
@testable import MasterAlgorithms

final class SupervisedFloodSpiralAgentTests: XCTestCase {
    
    let mazes = [
        [
            [1100, 0101, 0101, 0101, 0110],
            [1010, 1101, 0100, 0101, 0010],
            [1001, 0110, 1011, 1110, 1010],
            [1000, 0011, 1100, 0011, 1010],
            [1001, 0101, 0001, 0101, 0010],
            [1101, 0101, 0101, 0101, 0011]
        ],
        [
            [1100, 0101, 0100, 0100, 0101, 0111, 1100, 0100, 0100, 0101, 0101, 0101, 0101, 0101, 0101, 0110],
            [1010, 1000, 0011, 1000, 0101, 0100, 0010, 1011, 1000, 0101, 0101, 0101, 0101, 0101, 0110, 1010],
            [1010, 1001, 0110, 1010, 1100, 0010, 1001, 0101, 0011, 1100, 0101, 0101, 0101, 0101, 0011, 1010],
            [1010, 1100, 0011, 1001, 0010, 1011, 1100, 0101, 0101, 0001, 0101, 0101, 0101, 0101, 0110, 1010],
            [1010, 1010, 1100, 0110, 1001, 0111, 1000, 0101, 0101, 0101, 0101, 0101, 0101, 0101, 0011, 1010],
            [1010, 1000, 0010, 1001, 0100, 0101, 0011, 1100, 0101, 0101, 0100, 0101, 0101, 0101, 0101, 0011],
            [1001, 0010, 1001, 0111, 1001, 0100, 0110, 1010, 1101, 0110, 1000, 0110, 1100, 0110, 1100, 0110],
            [1100, 0001, 0101, 0101, 0101, 0011, 1010, 1000, 0110, 1010, 1010, 1001, 0011, 1001, 0010, 1010],
            [1010, 1100, 0101, 0101, 0101, 0110, 1011, 1001, 0011, 1010, 1001, 0101, 0101, 0110, 1010, 1010],
            [1010, 1010, 1100, 0101, 0101, 0011, 1100, 0101, 0101, 0001, 0101, 0100, 0101, 0011, 1010, 1010],
            [1001, 0010, 1010, 1100, 0101, 0101, 0001, 0101, 0101, 0101, 0110, 1001, 0101, 0101, 0010, 1010],
            [1100, 0010, 1010, 1010, 1100, 0101, 0101, 0101, 0101, 0101, 0001, 0101, 0101, 0101, 0010, 1010],
            [1010, 1010, 1010, 1010, 1001, 0101, 0101, 0101, 0101, 0101, 0110, 1100, 0101, 0101, 0001, 0010],
            [1010, 1010, 1010, 1000, 0101, 0101, 0101, 0101, 0101, 0110, 1010, 1001, 0101, 0101, 0110, 1010],
            [1010, 1010, 1001, 0011, 1100, 0100, 0101, 0101, 0101, 0011, 1010, 1100, 0101, 0101, 0011, 1010],
            [1011, 1001, 0101, 0101, 0011, 1001, 0101, 0101, 0101, 0101, 0001, 0001, 0101, 0101, 0101, 0011]
        ]
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getChain(spiralValue: Int, operation: FloodSpiralOperation, direction: MatrixDirection) {
        var operationValue = 0
        switch operation {
        case .idle:
            operationValue = 0
        case .forward:
            operationValue = 1
        case .turnLeft:
            operationValue = 2
        case .turnRight:
            operationValue = 3
        case .scanWall:
            operationValue = 4
        case .scanEmpty:
            operationValue = 5
        }
        var directionValue = 0
        switch direction {
        case .left:
            directionValue = 0
        case .right:
            directionValue = 1
        case .up:
            directionValue = 2
        case .down:
            directionValue = 3
        }
        
        let chain = "\(UInt8(spiralValue).binaryDescription)\(UInt8(operationValue).binaryDescription.dropFirst(6))\(UInt8(directionValue).binaryDescription.dropFirst(7))"
        
        print(chain)
        
        //print("\(UInt8(spiralValue).binaryDescription) \(UInt8(operationValue).binaryDescription.dropFirst(6)) \(UInt8(directionValue).binaryDescription.dropFirst(7))")
    }
    
    func testExample() throws {
        let maze = mazes[0]
        
        var supervisor = SupervisedFloodSpiralAgent(maze: maze, direction: .down)
        
        supervisor.agent.describe()
        
        supervisor.agent.explore()
        
        supervisor.agent.describe()
        
        for line in supervisor.track() {
            print(line)
        }
        
        print(supervisor.expirence)
    }
    
    func testExample2() throws {
        let maze = mazes[0]
        
        var supervisor = SupervisedFloodSpiralAgent(maze: maze, direction: .down)
        
        supervisor.agent.describe()
        
        supervisor.agent.explore()
        
        supervisor.agent.describe()
        
        for line in supervisor.track() {
            print(line)
        }
        
        print(supervisor.expirence)
        
        supervisor.reset(maze: maze, position: MatrixWall.build(maze).matrix.randomPosition(), direction: MatrixDirection.random())
        
        supervisor.agent.describe()
        
        supervisor.agent.explore()
        
        supervisor.agent.describe()
        
        for line in supervisor.track() {
            print(line)
        }
        
        print(supervisor.expirence)
    }
    
    func testExample3() throws {
        let maze = mazes[0]
        
        var supervisor = SupervisedFloodSpiralAgent(maze: maze, direction: .down)
        
        //supervisor.agent.describe()
        
        supervisor.agent.explore()
        
        //supervisor.agent.describe()
        
        let _ = supervisor.track()
        
        //for line in supervisor.track() {
        //    print(line)
        //}
        
        //print(supervisor.expirence)
        
        for _ in 1...100 {
            supervisor.reset(maze: maze, position: MatrixWall.build(maze).matrix.randomPosition(), direction: MatrixDirection.random())
            
            //supervisor.agent.describe()
            
            supervisor.agent.explore()
            
            //supervisor.agent.describe()
            
            let _ = supervisor.track()
            
            //for line in supervisor.track() {
            //    print(line)
            //}
            
            //print(supervisor.expirence)
        }
        
        supervisor.generateKnowledge()
        
        for key in supervisor.knowledge.keys.sorted() {
            print("\(key) \(supervisor.knowledge[key]!)")
        }
    }
    
    func testExample4() throws {
        let maze = mazes[1]
        
        var supervisor = SupervisedFloodSpiralAgent(maze: maze, direction: .down)
        
        //supervisor.agent.describe()
        
        supervisor.agent.explore()
        
        //supervisor.agent.describe()
        
        let _ = supervisor.track()
        
        //for line in supervisor.track() {
        //    print(line)
        //}
        
        //print(supervisor.expirence)
        
        for _ in 1...100 {
            supervisor.reset(maze: maze, position: MatrixWall.build(maze).matrix.randomPosition(), direction: MatrixDirection.random())
            
            //supervisor.agent.describe()
            
            supervisor.agent.explore()
            
            //supervisor.agent.describe()
            
            let _ = supervisor.track()
            
            //for line in supervisor.track() {
            //    print(line)
            //}
            
            //print(supervisor.expirence)
        }
        
        supervisor.knowledgeRatio = 10
        
        supervisor.generateKnowledge(keepAll: false, withSample: true)
        
        for key in supervisor.knowledgeSample.keys.sorted() {
            print("\(key) \(supervisor.knowledgeSample[key]!)")
        }
    }
    
    func testExample5() throws {
        let maze = mazes[1]
        
        var supervisor = SupervisedFloodSpiralAgent(maze: maze, direction: .down)
        
        //supervisor.agent.describe()
        
        supervisor.agent.explore()
        
        //supervisor.agent.describe()
        
        let _ = supervisor.track()
        
        //for line in supervisor.track() {
        //    print(line)
        //}
        
        //print(supervisor.expirence)
        
        for _ in 1...10 {
            supervisor.reset(maze: maze, position: MatrixWall.build(maze).matrix.randomPosition(), direction: MatrixDirection.random())
            
            //supervisor.agent.describe()
            
            supervisor.agent.explore()
            
            //supervisor.agent.describe()
            
            let _ = supervisor.track()
            
            //for line in supervisor.track() {
            //    print(line)
            //}
            
            //print(supervisor.expirence)
        }
        
        supervisor.generateKnowledge()
        
        for key in supervisor.knowledge.keys.sorted() {
            let chains = supervisor.knowledge[key]!.sorted(by: {_,_ in Bool.random()})
            let h = min(chains.count, 20)
            let k = chains.count - h
            print("\(key) \(chains.dropLast(k))")
        }
    }
    
}
