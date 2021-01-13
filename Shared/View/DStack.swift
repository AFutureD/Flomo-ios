//
//  DStack.swift
//  flomo
//
//  Created by AFuture on 2021/1/13.
//

import Foundation

public struct DStack<T> {
  private var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func push(element: T) {
    array.append(element)
  }

  public mutating func pop() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }

  public func peek() -> T? {
    return array.last
  }
}
