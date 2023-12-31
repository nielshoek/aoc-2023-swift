import Foundation

public class Day12 {
    public func Run() {
        print()
        let data = "Inputs/day12.txt".ToStringArray()
        print("Part 1: \(LogicA(input: data))")
        print("Part 2: \(LogicB(input: data))")
    }

    public func LogicA(input: [String]) -> Int {
        var count = 0
        for line in input {
            count += checkPossibilities(for: line)
        }

        return count
    }

    private func checkPossibilities(for line: String) -> Int {
        let parts = line.split(separator: " ")
        let row = String(parts[0])
        let groups = parseGroups(line: parts[1])
        return helper(row, groups)
    }

    public func LogicB(input: [String]) -> Int {
        var count = 0
        for line in input {
            count += checkPossibilities2(for: line.timesFive)
        }

        return count
    }

    private func checkPossibilities2(for line: String) -> Int {
        let parts = line.split(separator: " ")
        let row = String(parts[0])
        let groups = parseGroups(line: parts[1])
        return helper(row, groups)
    }

    var cache = [String: Int]()

    private func helper(_ springRow: String, _ groups: [Int]) -> Int {
        let cacheKey = springRow + groups.reduce(into: "") { acc, cur in acc += String(cur) }
        if let result = cache[cacheKey] {
            return result
        }

        var result = 0
        if groups.isEmpty {
            if springRow.filter({ $0 == "#" }).isEmpty {
                return 1
            }
            return 0
        }

        var groups = groups
        let originalRow = springRow
        let len = groups.removeLast()

        let indexOfLowestNumberSign = originalRow
            .firstIndex(of: "#")?
            .distance(in: originalRow) ?? Int.max
        let minLenForOtherGroups = groups.reduce(0) { acc, cur in acc + cur + 1 }
        let indexBasedOnLengthOfOthers = originalRow.count - (minLenForOtherGroups + len)
        let minLowestIndex = min(indexOfLowestNumberSign, indexBasedOnLengthOfOthers)
        let endIndex = minLowestIndex + len
        var rowForRegex = springRow.dropLast(springRow.count - endIndex)

        let regex = try! Regex("[?#]{\(len)}")
        var ranges = [Range<Int>]()
        while let regexMatch = rowForRegex.firstMatch(of: regex) {
            let low = regexMatch.range.lowerBound.distance(in: rowForRegex)
            let high = regexMatch.range.upperBound.distance(in: rowForRegex)
            ranges.append(low ..< high)
            var chars = [Character](rowForRegex)
            chars[low] = "_"
            rowForRegex = String.SubSequence(chars)
        }

        for range in ranges {
            let chars = [Character](originalRow)
            let rightNeighbor = range.upperBound < chars.count
                ? chars[range.upperBound]
                : Character(".")
            let leftNeighbor = range.lowerBound > 0
                ? chars[range.lowerBound - 1]
                : Character(".")
            if leftNeighbor != "#" && rightNeighbor != "#" {
                var springRow = springRow
                if (range.upperBound) < chars.count {
                    springRow = String(chars[(range.upperBound + 1)...])
                    result += helper(springRow, groups)
                } else if range.upperBound == chars.count && groups.isEmpty {
                    result += 1
                }
            }
        }
        cache[cacheKey] = result
        return result
    }

    private func parseGroups(line: String.SubSequence) -> [Int] {
        line.split(separator: ",").reversed().map { Int($0)! }
    }
}

private extension String {
    var timesFive: String {
        let left = components(separatedBy: " ")[0]
        var newLeft = left
        let right = components(separatedBy: " ")[1]
        var newRight = right
        for _ in 0 ..< 4 {
            newLeft += "?" + left
            newRight += "," + right
        }
        return newLeft + " " + newRight
    }
}
