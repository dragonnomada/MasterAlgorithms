//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 25/05/23.
//

import XCTest
@testable import MasterAlgorithms

final class FloodSpiralAgentTests: XCTestCase {
    
    let mazes = [
        [
            [1100, 0101, 0101, 0101, 0110],
            [1010, 1101, 0100, 0101, 0010],
            [1001, 0110, 1011, 1110, 1010],
            [1000, 0011, 1100, 0011, 1010],
            [1001, 0101, 0001, 0101, 1010],
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
    
    func testExample() throws {
        let maze = mazes[0]
        
        let agent = FloodSpiralAgent(maze: maze, position: (row: 2, column: 2))
        
        agent.describe()
    }
    
    func testSearchMinimumNeighbor() throws {
        let maze = mazes[0]
        
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
        
        var nextStackIndex = agent.stack.last ?? -1
        
        agent.goBackStack()
        
        agent.describe()
        
        XCTAssert(agent.index == nextStackIndex)
        XCTAssert(!agent.stack.contains(where: {$0 == nextStackIndex}))
        
        tests = [
            (value: 22, direction: MatrixDirection.left),
            (value: 21, direction: MatrixDirection.left),
            (value: 20, direction: MatrixDirection.up),
            (value: 7, direction: MatrixDirection.right),
            (value: 6, direction: MatrixDirection.up),
            (value: 19, direction: MatrixDirection.left),
            (value: 18, direction: MatrixDirection.up),
            (value: 17, direction: MatrixDirection.up),
            (value: 16, direction: MatrixDirection.right),
            (value: 15, direction: MatrixDirection.right),
            (value: 14, direction: MatrixDirection.right),
            (value: 13, direction: MatrixDirection.right),
        ]
        
        applyTests()
        
        agent.describe()
        
        checkEmptyNeighbors()
        
        nextStackIndex = agent.stack.last ?? -1
        
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
        
        nextStackIndex = agent.stack.last ?? -1
        
        agent.goBackStack()
        
        agent.describe()
        
        XCTAssert(agent.index == nextStackIndex)
        XCTAssert(!agent.stack.contains(where: {$0 == nextStackIndex}))
        
        checkEmptyNeighbors()
        
        nextStackIndex = agent.stack.last ?? -1
        
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
    }
    
    func testExplore() throws {
        let maze = mazes[0]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 2, column: 2))
        
        agent.describe()
        
        agent.explore()
        
        agent.describe()
    }
    
    func testExplore2() throws {
        let maze = mazes[0]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 0, column: 0))
        
        agent.describe()
        
        agent.explore()
        
        agent.describe()
    }
    
    func testFindGoal() throws {
        let maze = mazes[0]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 0, column: 0))
        
        agent.describe()
        
        agent.findGoal(goal: (2, 2))
        
        agent.describe()
    }
    
    func testFindGoal2() throws {
        let maze = mazes[1]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 0, column: 0))
        
        agent.describe()
        
        agent.findGoal(goal: (8, 8))
        
        agent.describe()
    }
    
    func testFindGoal3() throws {
        let maze = mazes[1]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 15, column: 0))
        
        agent.describe()
        
        agent.findGoal(goal: (8, 8))
        
        agent.describe()
    }
    
    func testFindGoal4() throws {
        let maze = mazes[1]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 0, column: 0))
        
        agent.describe()
        
        agent.findGoal(goal: (15, 15))
        
        agent.describe()
    }
    
    func testFindGoal5() throws {
        let maze = mazes[1]
        
        var agent = FloodSpiralAgent(maze: maze, position: (row: 15, column: 15))
        
        agent.describe()
        
        agent.findGoal(goal: (0, 0))
        
        agent.describe()
    }
}
