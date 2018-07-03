//
//  SortedDictionary.swift
//  Cdirent
//
//  Created by Jacob Williams on 6/30/18.
//

import Foundation

struct DateSortStruct<ValueType> {
    let value: ValueType
    let added: Date
    var used: Date = Date()

    init(_ value: ValueType, date: Date = Date()) {
        self.value = value
        self.added = date
    }

    mutating func update() {
        used = Date()
    }

    func date(for priority: SortPriority) -> Date {
        switch priority {
        case .added: return added
        case .used: return used
        }
    }
}

enum SortPriority {
    case added
    case used
}

extension DateSortStruct: Equatable where ValueType: Equatable {
    static func == (lhs: DateSortStruct<ValueType>, rhs: DateSortStruct<ValueType>) -> Bool {
        return lhs.value == rhs.value
    }
}

class DateSortedDictionary<KeyType, ValueType>: ExpressibleByDictionaryLiteral, Collection where KeyType: Hashable & Comparable, ValueType: Equatable {
    typealias Key = KeyType
    typealias Value = ValueType
    typealias Index = Int
    typealias Iterator = IndexingIterator<[(KeyType, ValueType)]>

    private var dict: [Int: DateSortStruct<ValueType>] = [:]
    private var indexes: [KeyType: Int] = [:]
    var sortPriority: SortPriority = .added

    var startIndex: Index {
        return dict.isEmpty ? endIndex : 0
    }

    var endIndex: Index {
        return dict.count
    }

    var keys: [KeyType] {
        var keys: [KeyType] = []
        keys.reserveCapacity(indexes.count)
        for (key, index) in indexes {
            keys.insert(key, at: index)
        }
        return keys
    }
    var values: [ValueType] {
        var values: [ValueType] = []
        values.reserveCapacity(dict.count)
        for (index, value) in dict {
            values.insert(value.value, at: index < values.endIndex ? index : values.endIndex)
        }
        return values
    }

    var ascending: [(KeyType, ValueType)] {
        return Array(zip(keys, values))
    }

    var descending: [(KeyType, ValueType)] {
        return Array(ascending.reversed())
    }

    required init(dictionaryLiteral elements: (KeyType, ValueType)...) {
        for element in elements {
            insert(element)
        }
    }

    func makeIterator() -> Iterator {
        return ascending.makeIterator()
    }

    private func insert(_ element: (KeyType, ValueType)) {
        insert(key: element.0, value: DateSortStruct(element.1))
    }

    private func insert(key: KeyType, value: DateSortStruct<ValueType>) {
        if let index = indexes[key] {
            guard let val = dict[index] else {
                fatalError("Key exists in indexes, but not in the sorted values dictionary")
            }

            guard val != value else { return }
            remove(key: key)
        }

        let insertIndex = determineIndex(of: value)
        shiftIndexes(by: 1, from: insertIndex)
        indexes[key] = insertIndex
        dict[insertIndex] = value
    }

    private func remove(key: KeyType) {
        if let index = indexes[key] {
            dict.removeValue(forKey: index)
            shiftIndexes(by: -1, from: index)
        }
        indexes.removeValue(forKey: key)
    }

    private func determineIndex(of value: DateSortStruct<ValueType>) -> Int {
        for (index, val) in dict {
            switch sortPriority {
            case .added:
                if value.added < val.added {
                    return index
                }
            case .used:
                if value.used < val.used {
                    return index
                }
            }
        }
        return values.count
    }

    private func shiftIndexes(by shiftAmount: Int, from index: Int) {
        guard shiftAmount != 0 else { return }

        // Existentials would make this cleaner
        let range = (index..<dict.count)
        if shiftAmount > 0 {
            for idx in range.reversed() {
                dict[idx + shiftAmount] = dict.removeValue(forKey: idx)
            }
            for (key, idx) in indexes {
                if idx >= index {
                    indexes[key]! += shiftAmount
                }
            }
        } else {
            for idx in range {
                dict[idx + shiftAmount] = dict.removeValue(forKey: idx)
            }
            for (key, idx) in indexes {
                if idx >= index {
                    indexes[key]! += shiftAmount
                }
            }
        }
    }

    private enum Comparison {
        case greater
        case lesser
    }

    func matching(_ conditions: Conditions, priority: SortPriority = .added) -> [(KeyType, ValueType)] {
        let thresholdCount: Int
        let originalPriority = sortPriority
        sortPriority = priority
        let sorted: [(KeyType, ValueType)]
        let date: Date
        let comparison: Comparison
        var matches: [(KeyType, ValueType)] = []

        switch conditions {
        case .older(let time, let threshold):
            if threshold < 1.0 {
                thresholdCount = Int(Double(count) * (threshold == -1.0 ? 1.0 : threshold))
            } else {
                thresholdCount = Int(threshold)
            }
            sorted = ascending
            date = Date(timeInterval: time.timeInterval, since: Date())
            comparison = .lesser
        case .newer(let time, let threshold):
            if threshold < 1.0 {
                thresholdCount = Int(Double(count) * (threshold == -1.0 ? 1.0 : threshold))
            } else {
                thresholdCount = Int(threshold)
            }
            sorted = descending
            date = Date(timeInterval: time.timeInterval, since: Date())
            comparison = .greater
        }
        sortPriority = originalPriority
        for (key, value) in sorted {
            guard let index = indexes[key] else {
                fatalError("Key exists in the sorted dictionary, but not in the indexes")
            }
            guard let item = dict[index] else {
                fatalError("Key exists in indexes, but not in the dictionary")
            }
            let itemDate = item.date(for: priority)
            switch comparison {
            case .greater:
                guard itemDate > date else { break }
            case .lesser:
                guard itemDate < date else { break }
            }
            matches.append((key, value))
        }

        guard matches.count >= thresholdCount else { return [] }

        return matches
    }

    @discardableResult
    func removeValue(forKey key: KeyType) -> ValueType? {
        if let value = self[key] {
            self[key] = nil
            return value
        }

        return nil
    }

    subscript(key: KeyType) -> ValueType? {
        get {
            guard let index = indexes[key] else { return nil }
            dict[index]?.update()
            return dict[index]?.value
        }
        set {
            guard let newValue = newValue else {
                return remove(key: key)
            }

            insert(key: key, value: DateSortStruct(newValue))
        }
    }

    subscript(key: KeyType, `default` value: ValueType) -> ValueType {
        guard let index = indexes[key] else { return value }
        return dict[index]?.value ?? value
    }

    subscript(position: Int) -> (KeyType, ValueType) {
        let key: KeyType
        let value: ValueType

        if let _key = indexes.first(where: { return $0.value == position })?.key {
            key = _key
        } else {
            key = keys[position]
        }

        if let _value = dict[position]?.value {
            value = _value
        } else {
            value = values[position]
        }

        return (key, value)
    }

    func index(after i: Int) -> Int {
        return i + 1
    }
}