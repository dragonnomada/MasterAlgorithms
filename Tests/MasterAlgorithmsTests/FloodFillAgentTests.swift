//
//  FloodFillAgentTests.swift
//  
//
//  Created by Alan Badillo Salas on 17/05/23.
//

import XCTest
@testable import MasterAlgorithms

final class FloodFillAgentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let walls = [
            (1, 6),
            (2, 7),
            (3, 8),
            (5, 6),
            (6, 1),
            (6, 5),
            (6, 11),
            (7, 2),
            (8, 3),
            (8, 13),
            (10, 15),
            (11, 6),
            (11, 12),
            (12, 11),
            (12, 13),
            (12, 17),
            (13, 8),
            (13, 12),
            (13, 14),
            (14, 13),
            (15, 10),
            (16, 17),
            (16, 21),
            (17, 12),
            (17, 16),
            (18, 19),
            (18, 23),
            (19, 18),
            (21, 16),
            (23, 18),
        ]
         
        var agent = FloodFillAgent(debug: false, matrix: Matrix.from(6, 5), walls: walls)

        let path = agent.goToGoal(at: (row: 2, column: 2), withDescription: false)

        print("PATH TO GOAL: \(path)")
        
        agent.describe()
        
        XCTAssert(path == [0, 1, 2, 3, 4, 9, 8, 7, 12])
    }
    
    func testWallBuilding() throws {
        
        var agent = FloodFillAgent(debug: false, matrixWall: MatrixWall.build([
            [1100, 0101, 0101, 0101, 0110],
            [1010, 1101, 0100, 0101, 0010],
            [1001, 0110, 1011, 1110, 0010],
            [1000, 0011, 1100, 0011, 0010],
            [1001, 0101, 0001, 0101, 0011],
        ]))

        let path = agent.goToGoal(at: (row: 2, column: 2), withDescription: false)
//        let path = agent.goToGoal(at: (row: 2, column: 3), withDescription: false)

        print("PATH TO GOAL: \(path)")
        
        agent.describe()
        
        XCTAssert(path == [0, 1, 2, 3, 4, 9, 8, 7, 12])
        //        XCTAssert(path == [0, 5, 10, 11, 16, 15, 20, 21, 22, 17, 18, 13])
        
    }
    
    func testNotReachable() throws {
        
        var agent = FloodFillAgent(debug: false, matrixWall: MatrixWall.build([
            [1100, 0101, 0101, 0101, 0110],
            [1010, 1101, 0100, 0101, 0010],
            [1001, 0110, 1011, 1111, 0010],
            [1000, 0011, 1100, 0111, 0010],
            [1001, 0101, 0001, 0101, 0011],
        ]))

        let path = agent.goToGoal(at: (row: 2, column: 3), withDescription: false)

        print("PATH TO GOAL: \(path)")
        
        agent.describe()
        
        XCTAssert(path == [])
        
    }
    
    func testMetrics() throws {
        
        var agent = FloodFillAgent(debug: false, matrixWall: MatrixWall.build([
            [1100, 0110],
            [1001, 0011],
        ]))

        let path = agent.goToGoal(at: (row: 1, column: 1), withDescription: false)

        print("PATH TO GOAL: \(path)")
        
        agent.describe()
        
        XCTAssert(path == [0, 1, 3])
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
