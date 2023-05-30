//
//  File.swift
//  
//
//  Created by Alan Badillo Salas on 18/05/23.
//

import Foundation

public typealias MatrixIndex = (row: Int, column: Int)
public typealias RawIndex = Int
public typealias MatrixRow = [Int]
public typealias RawIndexPath = [Int]

public enum MatrixDirection: String {
    case left = "LEFT"
    case right = "RIGHT"
    case up = "UP"
    case down = "DOWN"
    
    public static func random() -> MatrixDirection {
        var directions: [MatrixDirection] = [.right, .up, .left, .down]
        directions.sort(by: { _, _ in Bool.random() })
        return directions.first!
    }
}

public struct Matrix {
    
    public let rows: Int
    public let columns: Int
    public let defaultValue: Int
    private var data: [[Int]]
    
    public var size: Int {
        rows * columns
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
    
    public var firstIndex: MatrixIndex {
        (row: 0, column: 0)
    }
    
    public var firstRawIndex: RawIndex {
        getRawIndex(at: firstIndex)!
    }
    
    public var lastIndex: MatrixIndex {
        (row: lastRow, column: lastColumn)
    }
    
    public var lastRawIndex: RawIndex {
        getRawIndex(at: lastIndex)!
    }
    
    public init(rows: Int, columns: Int, defaultValue: Int = -1) {
        self.rows = rows
        self.columns = columns
        self.defaultValue = defaultValue
        
        var matrix: [[Int]] = []
        
        for _ in 0..<rows {
            var row: [Int] = []
            for _ in 0..<columns {
                row.append(defaultValue)
            }
            matrix.append(row)
        }
        
        self.data = matrix
    }
    
    public static func squared(_ n: Int, defaultValue: Int = -1) -> Matrix {
        return Matrix(rows: n, columns: n, defaultValue: defaultValue)
    }
    
    public static func from(_ n: Int, _ m: Int, defaultValue: Int = -1) -> Matrix {
        return Matrix(rows: n, columns: m, defaultValue: defaultValue)
    }
    
    public func describe() {
        print("Matrix \(rows)x\(columns)")
        for i in 0..<rows {
            let row = data[i]
            for j in 0..<columns {
                let value = row[j]
                print(" \(value == defaultValue ? "*" : "\(String(format: "%03d", value))") ", terminator: "")
            }
            print()
        }
    }
    
    public func randomPosition() -> MatrixIndex {
        let row = Int.random(in: 0..<rows)
        let column = Int.random(in: 0..<columns)
        return (row: row, column: column)
    }
    
    public func row(_ rowIndex: Int) -> MatrixRow {
        return data[rowIndex]
    }
    
    public func existsIndex(at index: MatrixIndex) -> Bool {
        guard let _ = getRawIndex(at: index)
        else { return false }
        return true
    }
    
    public func existsRawIndex(from rawIndex: RawIndex) -> Bool {
        guard let _ = getIndex(from: rawIndex)
        else { return false }
        return true
    }
    
    public func getRawIndex(at index: MatrixIndex) -> RawIndex? {
        guard index.row >= 0 && index.row < rows && index.column >= 0 && index.column < columns
        else { return nil }
        return index.row * columns + index.column
    }
    
    public func getIndex(from rawIndex: RawIndex) -> MatrixIndex? {
        guard rawIndex >= 0 && rawIndex < size
        else { return nil }
        let row = Int(rawIndex / columns)
        let column = rawIndex % columns
        return (row, column)
    }
    
    public func selectIndex(at index: MatrixIndex, direction: MatrixDirection) -> MatrixIndex? {
        switch direction {
        case .left:
            guard let rawIndex = getRawIndex(at: (index.row, index.column - 1))
            else { return nil }
            return getIndex(from:  rawIndex)
        case .right:
            guard let rawIndex = getRawIndex(at: (index.row, index.column + 1))
            else { return nil }
            return getIndex(from:  rawIndex)
        case .up:
            guard let rawIndex = getRawIndex(at: (index.row - 1, index.column))
            else { return nil }
            return getIndex(from:  rawIndex)
        case .down:
            guard let rawIndex = getRawIndex(at: (index.row + 1, index.column))
            else { return nil }
            return getIndex(from:  rawIndex)
        }
    }
    
    public func selectIndex(from rawIndex: RawIndex, direction: MatrixDirection) -> MatrixIndex? {
        guard let index = getIndex(from: rawIndex)
        else { return nil }
        return selectIndex(at: index, direction: direction)
    }
    
    public func selectRawIndex(at index: MatrixIndex, direction: MatrixDirection) -> RawIndex? {
        guard let selectedIndex = selectIndex(at: index, direction: direction)
        else { return nil }
        return getRawIndex(at: selectedIndex)
    }
    
    public func selectRawIndex(from rawIndex: RawIndex, direction: MatrixDirection) -> RawIndex? {
        guard let selectedIndex = selectIndex(from: rawIndex, direction: direction)
        else { return nil }
        return getRawIndex(at: selectedIndex)
    }
    
    public func getValue(at index: MatrixIndex) -> Int? {
        guard existsIndex(at: index)
        else { return nil }
        return data[index.row][index.column]
    }
    
    public func getValue(from rawIndex: RawIndex) -> Int? {
        guard let index = getIndex(from: rawIndex)
        else { return nil }
        return getValue(at: index)
    }
    
    public mutating func setValue(_ value: Int, at index: MatrixIndex) {
        if existsIndex(at: index) {
            data[index.row][index.column] = value
        }
    }
    
    public mutating func setValue(_ value: Int, from rawIndex: RawIndex) {
        if let index = getIndex(from: rawIndex) {
            setValue(value, at: index)
        }
    }
    
}
