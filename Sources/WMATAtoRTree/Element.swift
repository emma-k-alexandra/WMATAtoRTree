//
//  Element.swift
//  
//
//  Created by Emma K Alexandra on 11/7/19.
//
import RTree
import WMATA
import Foundation

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
        set(newValue) {
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
    let entrance: StationEntrance
    
    func minimumBoundingRectangle() -> BoundingRectangle<Point> {
        return BoundingRectangle(lower: self.point, upper: self.point)
        
    }
    
    func distanceSquared(point: Point) -> Double {
        pow(self.point.x, 2) + pow(self.point.y, 2)
        
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
