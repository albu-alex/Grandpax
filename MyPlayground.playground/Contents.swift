
import Foundation

protocol A {
    var x: Double { get set }
    var y: Double { get set }
}

struct B: A {
    var x: Double
    
    var y: Double
}
struct C: A {
    var x: CGFloat
    
    var y: CGFloat
}
