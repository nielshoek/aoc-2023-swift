let testMap = [
    ".....",
    ".....",
    "....#",
    ".....",
    "..#..",
]

struct GalaxyPoint {
    let row: Int
    let col: Int

    func distance(from other: GalaxyPoint) -> Int {
        let xDiff = abs(row - other.row)
        let yDiff = abs(col - other.col)
        return xDiff + yDiff
    }
}

public struct Day11 {
    public func Run() {
        print()
        let data = "Inputs/day11.txt".ToStringArray()
        print("Part test: \(LogicA(input: testMap))")
        // print("Part 1: \(LogicA(input: data))")
        print("Part 2: \(LogicB(input: testMap))")
    }

    public func LogicA(input: [String]) -> Int {
        var grid = input.reduce(into: [[Character]]()) { acc, cur in
            acc.append(cur.map(Character.init))
        }
        grid = expandGrid(grid)
        let galaxies = extractGalaxyPoints(grid)
// grid.print()
        var distanceAccumulator = 0
        for (i, currentGalaxy) in galaxies.enumerated() {
            for otherGalaxy in galaxies.dropFirst(i) {
                let distance = currentGalaxy.distance(from: otherGalaxy)
                print("A: \(distance)")
                distanceAccumulator += distance
            }
        }

        return distanceAccumulator
    }

    public func LogicB(input: [String]) -> Int {
        var grid = input.reduce(into: [[Character]]()) { acc, cur in
            acc.append(cur.map(Character.init))
        }
        grid = expandGrid2(grid)
        let galaxies = extractGalaxyPoints(grid)
// grid.print()
        var distanceAccumulator = 0
        for (i, currentGalaxy) in galaxies.enumerated() {
            for otherGalaxy in galaxies.dropFirst(i) {
                let distance = currentGalaxy.distance(from: otherGalaxy)
                print("B: \(distance)")
                distanceAccumulator += distance
            }
        }

        return distanceAccumulator
    }

    private func extractGalaxyPoints(_ grid: [[Character]]) -> [GalaxyPoint] {
        var result = [GalaxyPoint]()
        for (i, row) in grid.enumerated() {
            for (j, col) in row.enumerated() {
                if col == "#" {
                    result.append(GalaxyPoint(row: i, col: j))
                }
            }
        }
        return result
    }

    private func expandGrid(_ originalGrid: [[Character]]) -> [[Character]] {
        var result = [[Character]]()
        var colsToExpand = [Int]()
        outer: for i in 0 ..< originalGrid[0].count {
            for row in originalGrid {
                if row[i] == "#" {
                    continue outer
                }
            }
            colsToExpand.append(i)
        }

        var gridWithDoubledRows = [[Character]]()
        for row in originalGrid {
            if row.contains("#") {
                gridWithDoubledRows.append(row)
            } else {
                gridWithDoubledRows.append(row)
                gridWithDoubledRows.append(row)
            }
        }

        for _ in 0 ..< gridWithDoubledRows.count {
            result.append([Character]())
        }

        var lastCol = 0
        for i in colsToExpand {
            for rowIndex in 0 ..< gridWithDoubledRows.count {
                let part = gridWithDoubledRows[rowIndex][lastCol ..< i]
                result[rowIndex].append(contentsOf: part)
                result[rowIndex].append(".")
            }
            lastCol = i
        }
        for rowIndex in 0 ..< gridWithDoubledRows.count {
            let part = gridWithDoubledRows[rowIndex][lastCol ..< gridWithDoubledRows[rowIndex].count]
            result[rowIndex].append(contentsOf: part)
        }

        return result
    }

    private func expandGrid2(_ originalGrid: [[Character]]) -> [[Character]] {
        let EXPAND_FACTOR = 2
        var result = [[Character]]()
        var colsToExpand = [Int]()
        outer: for i in 0 ..< originalGrid[0].count {
            for row in originalGrid {
                if row[i] == "#" {
                    continue outer
                }
            }
            colsToExpand.append(i)
        }

        var gridWithDoubledRows = [[Character]]()
        for (i, row) in originalGrid.enumerated() {
            if row.contains("#") {
                gridWithDoubledRows.append(row)
            } else {
                for _ in 0 ..< EXPAND_FACTOR {
                    gridWithDoubledRows.append(row)
                }
            }
        }

        for _ in 0 ..< gridWithDoubledRows.count {
            result.append([Character]())
        }

        var lastCol = 0
        for i in colsToExpand {
            for rowIndex in 0 ..< gridWithDoubledRows.count {
                let part = gridWithDoubledRows[rowIndex][lastCol ..< i]
                result[rowIndex].append(contentsOf: part)
                result[rowIndex].append(contentsOf: [Character](repeating: ".", count: EXPAND_FACTOR - 1))
            }
            lastCol = i
        }
        for rowIndex in 0 ..< gridWithDoubledRows.count {
            let part = gridWithDoubledRows[rowIndex][lastCol ..< gridWithDoubledRows[rowIndex].count]
            result[rowIndex].append(contentsOf: part)
        }

        return result
    }
}

extension [[Character]] {
    func print() {
        for line in self {
            Swift.print(line)
        }
        Swift.print()
    }
}
