//: Playground - noun: a place where people can play

import UIKit

struct Beer: CustomDebugStringConvertible {
    var brandName: String
    var volume: Int
    
    var debugDescription: String {
        return "\(brandName): \(volume) ml"
    }
    
    public var isCan: Bool {
        return (self.volume < 350)
    }
}


struct BeerContainer {
    let elements: [Beer]
    var i = 0
    
    init(elements: [Beer]) {
        self.elements = elements
    }
}

extension BeerContainer: IteratorProtocol {
    typealias Element = Beer
    
    mutating func next() -> Element? {
        defer {
            i+=1
        }
        return i<elements.count ? elements[i] : nil
    }
}

// Origin
//struct VendorMachine {
//    let elements: [Beer]
//}

// Using IndexingIterator
//extension VendorMachine: Sequence {
//    typealias Iterator = IndexingIterator<[Beer]>
//    
//    func makeIterator() -> Iterator {
//        return elements.makeIterator()
//    }
//    
//}

// Try AnyIterator
//extension VendorMachine: Sequence {
//    typealias Iterator = AnyIterator<Beer>
//    
//    func makeIterator() -> Iterator {
//        var iterator = elements.makeIterator()
//        return AnyIterator {
//            iterator.next()
//        }
//    }
//}

// Use our Iterator
//extension VendorMachine: Sequence {
//    typealias Iterator = BeerContainer
//    
//    func makeIterator() -> Iterator {
//        return BeerContainer(elements: self.elements)
//    }
//}

struct VendorMachine: Sequence {
    typealias Iterator = AnyIterator<Beer>
    
    let elements: [Beer]
    
    func makeIterator() -> Iterator {
        var i = self.elements.startIndex
        return AnyIterator {
            defer {
                i+=1
            }
            return i<self.elements.count ? self.elements[i] : nil
        }
    }
}


let aOrionBeer = Beer(brandName: "Orion", volume: 300)
let aSaporoBeer = Beer(brandName: "Saporo", volume: 380)
let aTaiwanBeer = Beer(brandName: "TaiwanBeer", volume: 330)
let aAsahiBeer = Beer(brandName: "Asahi", volume: 420)


var aBeerContainer = BeerContainer(elements: [ aOrionBeer, aSaporoBeer, aTaiwanBeer, aAsahiBeer ])

while let aBeer = aBeerContainer.next() {
    print(aBeer)
}

let aMachine = VendorMachine(elements: [ aOrionBeer, aSaporoBeer, aTaiwanBeer, aAsahiBeer ])
for beer in aMachine {
    print(beer)
}

let sortedBeers = aMachine.sorted { $0.volume>$1.volume }
print(sortedBeers)

let largeBeers = aMachine.filter { $0.volume>400 }
print( largeBeers )

let totalVolume = aMachine.reduce(0) { return $0+$1.volume }
print(totalVolume)

