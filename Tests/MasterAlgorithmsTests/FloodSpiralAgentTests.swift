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
        
        let tests = [
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
        
        let (neighborValue, neighborDirection, neighborsTotal) = agent.searchMinimumNeighbor()
        
        XCTAssert(neighborValue == nil)
        XCTAssert(neighborDirection == nil)
        XCTAssert(neighborsTotal == 0)
        
        agent.describe()
    }
}
