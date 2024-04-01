import Cocoa

func foo(arr: [Int]?) -> Int {
    return (arr?.randomElement() ?? (1...100).randomElement()!)
}

print(foo(arr: [1]))
