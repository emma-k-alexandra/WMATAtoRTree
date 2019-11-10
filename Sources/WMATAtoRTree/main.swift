import WMATA
import RTree
import Foundation

/// URL to store the tree at
var path = URL(fileURLWithPath: FileManager().currentDirectoryPath)
path.appendPathComponent("Entrances.rtree")

/// My R-Tree containing my spatial objects
var tree = try RTree<Element>(path: path)

/// Get API key from environemnt
guard let apiKey = ProcessInfo.processInfo.environment["WMATA_API_KEY"] else {
    print("WMATA_API_KEY not set in environment")
    exit(1)
    
}

/// Query Metro API for station entrances
MetroRail(key: apiKey).entrances(at: nil) { result in
    switch result {
    case .success(let entrances):
        for entrance in entrances.entrances {
            /// create and insert elements into R-Tree
            let element = Element(point: Point2D(x: entrance.latitude, y: entrance.longitude), entrance: entrance)
            
            try! tree.insert(element)
            
        }
        
    case .failure(let error):
        print(error)
        exit(1)
        
    }
    
}

Thread.sleep(forTimeInterval: 60)
