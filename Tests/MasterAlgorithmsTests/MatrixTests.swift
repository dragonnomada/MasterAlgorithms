//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 24/05/23.
//

import XCTest
@testable import MasterAlgorithms

final class MatrixTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let matrixSpiral = MatrixSpiral(dimension: 10)
        
        matrixSpiral.describe()
    }
    
    func testNeighbors() throws {
        let matrixSpiral = MatrixSpiral(dimension: 5)
        
        matrixSpiral.describe()
        
        var neighbors = matrixSpiral.neighbors(of: 1)
        
        print(neighbors.map({$0.value}))
        
        XCTAssert(neighbors.map({ $0.value }) == [2, 4, 6, 8])
        
        neighbors = matrixSpiral.neighbors(of: 20)
        
        print(neighbors.map({$0.value}))
        
        XCTAssert(neighbors.map({ $0.value }) == [7, 19, 21])
        
        neighbors = matrixSpiral.neighbors(of: 25)
        
        print(neighbors.map({$0.value}))
        
        XCTAssert(neighbors.map({ $0.value }) == [10, 24])
    }
    
    func testRelations() throws {
        let matrixSpiral = MatrixSpiral(dimension: 5)
        
        matrixSpiral.describe()
        
        print(matrixSpiral.relations())
        print(matrixSpiral.walls().map({ ($0, $1) }))
    }
}
