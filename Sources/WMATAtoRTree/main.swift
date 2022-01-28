import WMATA
import RTree
import Foundation

/// URL to store the tree at
var path = URL(fileURLWithPath: FileManager().currentDirectoryPath)
 path.appendPathComponent("AllEntrances.rtree")
// path.appendPathComponent("ElevatorEntrances.rtree")
//path.appendPathComponent("EscalatorEntrances.rtree")


print(path)

/// My R-Tree containing my spatial objects
var tree = try RTree<Element>(path: path, decoder: WMATAJSONDecoder())

let TEST_API_KEY = "9e38c3eab34c4e6c990828002828f5ed" // Get your own @ https://developer.wmata.com using this one will probably result in some weird behavior

let dispatchGroup = DispatchGroup()

dispatchGroup.enter()

DispatchQueue.global().async {
    /// Query Metro API for station entrances
    Rail.StationEntrances(key: TEST_API_KEY).request { result in
        switch result {
        case .success(let entrances):
            for entrance in entrances.entrances {
//            for entrance in entrances.entrances.filter({ $0.entranceType == .elevator }) {
//            for entrance in entrances.entrances.filter({ $0.entranceType == .escalator }) {
                print(entrance)
                /// create and insert elements into R-Tree
                let element = Element(point: Point2D(x: entrance.latitude, y: entrance.longitude), entrance: entrance)
                
                try! tree.insert(element)
            }
            exit(0)
        case .failure(let error):
            print(error)
            exit(1)
        }
    }
}

dispatchGroup.wait()

/// Simple 2D vector
struct Point2D: PointN {
    typealias Scalar = Double
    
    var x: Scalar
    var y: Scalar
    
    init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    func dimensions() -> Int {
        2
    }
    
    static func from(value: Double) -> Self {
        Point2D(x: value, y: value)
    }
    
    subscript(index: Int) -> Scalar {
        get {
            if index == 0 {
                return self.x
            } else {
                return self.y
            }
            
        }
        set {
            if index == 0 {
                self.x = newValue
            } else {
                self.y = newValue
            }
        }
    }
}

extension Point2D: Equatable {
    static func == (lhs: Point2D, rhs: Point2D) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

/// SpatialObject to store a 2d vector and a station entrance
struct Element: SpatialObject {
    typealias Point = Point2D
        
    let point: Point
    let entrance: Rail.StationEntrances.Response.Entrance
    
    func minimumBoundingRectangle() -> BoundingRectangle<Point> {
        return BoundingRectangle(lower: self.point, upper: self.point)
    }
    
    func distanceSquared(point: Point) -> Double {
        pow(point.x - self.point.x, 2) + pow(point.y - self.point.y, 2)
    }
    
    func contains(point: Point) -> Bool {
        self.distanceSquared(point: point) <= Point.Scalar.zero
    }
    
}

extension Element: Equatable {
    static func == (lhs: Element, rhs: Element) -> Bool {
        lhs.point == rhs.point
    }
}
