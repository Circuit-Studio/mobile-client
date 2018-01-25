//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class DrawingView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: 0, y: 0))
        aPath.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        
        aPath.close()
        
        UIColor.black.set()
        aPath.stroke()
        
    }
}

class ViewController: UIViewController {
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let myView = DrawingView(frame: self.view.frame)
        
        view.addSubview(myView)
        self.view = view
    }
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()
