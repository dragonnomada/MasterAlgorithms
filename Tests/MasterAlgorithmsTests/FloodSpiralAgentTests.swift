//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 25/05/23.
//

import XCTest
@testable import MasterAlgorithms

final class FloodSpiralAgentTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let maze = [
            [1100, 0101, 0101, 0101, 0110],
            [1010, 1101, 0100, 0101, 0010],
            [1001, 0110, 1011, 1110, 1010],
            [1000, 0011, 1100, 0011, 1010],
            [1001, 0101, 0001, 0101, 1010],
            [1101, 0101, 0101, 0101, 0011]
        ]
        
        let agent = FloodSpiralAgent(maze: maze, position: (row: 2, column: 2))
        
        agent.describe()
    }
    
    func testSearchMinimumNeighbor() throws {
        let maze = [
            [1100, 0101, 0101, 0101, 0110],
            [1010, 1101, 0100, 0101, 0010],
            [1001, 0110, 1011, 1110, 0010],
            [1000, 0011, 1100, 0011, 0010],
            [1001, 0101, 0001, 0101, 0010],
            [1101, 0101, 0101, 0101, 0011]
        ]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 2, column: 2))
        
        agent.describe()
        
        var tests = [
            (value: 4, direction: MatrixDirection.up),
            (value: 3, direction: MatrixDirection.right),
            (value: 12, direction: MatrixDirection.right),
            (value: 11, direction: MatrixDirection.down),
            (value: 10, direction: MatrixDirection.down),
            (value: 25, direction: MatrixDirection.down),
            (value: 24, direction: MatrixDirection.left),
            (value: 23, direction: MatrixDirection.left),
            (value: 8, direction: MatrixDirection.up),
            (value: 9, direction: MatrixDirection.right),
            (value: 2, direction: MatrixDirection.up),
        ]
        
        let applyTests = {
            for test in tests {
                let (neighborValue, neighborDirection, neighborsTotal) = agent.searchMinimumNeighbor()
                
                if neighborsTotal > 1 {
                    if let index = agent.index {
                        agent.stack.append(index)
                    }
                }
                
                XCTAssert(neighborValue == test.value)
                XCTAssert(neighborDirection == test.direction)
                
                guard let direction = neighborDirection
                else {
                    XCTFail("Invalid neighbor direction")
                    return
                }
                
                agent.turnAlign(direction: direction)
                
                agent.forward()
            }
        }
        
        applyTests()
        
        let checkEmptyNeighbors = {
            let (neighborValue, neighborDirection, neighborsTotal) = agent.searchMinimumNeighbor()
            
            XCTAssert(neighborValue == nil)
            XCTAssert(neighborDirection == nil)
            XCTAssert(neighborsTotal == 0)
            
            agent.describe()
        }
        
        checkEmptyNeighbors()
        
        var nextStackIndex = agent.stack[0]
        
        agent.goBackStack()
        
        agent.describe()
        
        XCTAssert(agent.index == nextStackIndex)
        XCTAssert(!agent.stack.contains(where: {$0 == nextStackIndex}))
        
        tests = [
            (value: 5, direction: MatrixDirection.left),
        ]
        
        applyTests()
        
        agent.describe()
        
        checkEmptyNeighbors()
        
        nextStackIndex = agent.stack[0]
        
        agent.goBackStack()
        
        agent.describe()
        
        XCTAssert(agent.index == nextStackIndex)
        XCTAssert(!agent.stack.contains(where: {$0 == nextStackIndex}))
        
        tests = [
            (value: 13, direction: MatrixDirection.up),
            (value: 14, direction: MatrixDirection.left),
            (value: 15, direction: MatrixDirection.left),
            (value: 16, direction: MatrixDirection.left),
            (value: 17, direction: MatrixDirection.left),
            (value: 18, direction: MatrixDirection.down),
            (value: 19, direction: MatrixDirection.down),
            (value: 6, direction: MatrixDirection.right),
            (value: 7, direction: MatrixDirection.down),
            (value: 20, direction: MatrixDirection.left),
            (value: 21, direction: MatrixDirection.down),
            (value: 22, direction: MatrixDirection.right),
        ]
        
        applyTests()
        
        agent.describe()
        
        checkEmptyNeighbors()
        
        nextStackIndex = agent.stack[0]
        
        agent.goBackStack()
        
        agent.describe()
        
        XCTAssert(agent.index == nextStackIndex)
        XCTAssert(!agent.stack.contains(where: {$0 == nextStackIndex}))
        
        tests = [
            (value: 48, direction: MatrixDirection.down),
            (value: 47, direction: MatrixDirection.left),
            (value: 46, direction: MatrixDirection.left),
            (value: 45, direction: MatrixDirection.left),
            (value: 44, direction: MatrixDirection.left),
        ]
        
        applyTests()
        
        agent.describe()
        
        checkEmptyNeighbors()
        
        nextStackIndex = agent.stack[0]
        
        agent.goBackStack()
        
        agent.describe()
        
        XCTAssert(agent.index == nextStackIndex)
        XCTAssert(!agent.stack.contains(where: {$0 == nextStackIndex}))
        
    }
}
