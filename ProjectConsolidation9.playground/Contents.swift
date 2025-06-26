import UIKit

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

var test1 = UIView()
test1.bounceOut(duration: 4)

extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            closure()
        }
    }
}

var num = 1
var num2 = 5
var num3 = -3
num.times {
    print("Hello world")
}
num2.times {
    print("Hello from 2")
}
num3.times {
    print("Hi from 3!")
}

extension Array where Element:Comparable {
    mutating func remove(item: Element) {
        if let i = self.firstIndex(of: item) {
            self.remove(at: i)
        }
    }
}

var arr1 = ["Hello", "this", "is", "Isaac", "is", "this", "you?"]
arr1.remove(item: "this")
