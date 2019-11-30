//
//  CustomView.swift
//  PerceptronV2
//
//  Created by Martin Nasierowski on 16/11/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import CoreGraphics

class Canvas: UIView {
    
    var points = [CGPoint]()
    var table_points = [Float](repeating: 0.0, count: 2501) // musze potem zamienic [index 0] na jedynkę
    
    var context: CGContext!
    
    var delegate: SetPointsDelegate!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        context = UIGraphicsGetCurrentContext()
        
        for point in points {
            let clipPath = UIBezierPath(roundedRect: CGRect(x: point.x * 4, y: point.y * 4, width: 4, height: 4), cornerRadius: 0.0).cgPath
            context.addPath(clipPath)
            context.setFillColor(UIColor.red.cgColor)
            context.closePath()
            context.fillPath()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        
        let x = (location.x)
        let y = (location.y)
        
        if x > 0 && y > 0 && x < 200 && y < 200 {
            points.append(CGPoint(x: Int(x)/4, y: Int(y)/4))
            setNeedsDisplay()
        }
        
        setPoints()
    }
    
    func setPoints() {
        table_points = [Float](repeating: 0.0, count: 2501)
        table_points[0] = 1
        
        points.forEach { (point) in
            table_points[(Int(point.x)) + ( (Int(point.y)) * 50 ) + 1] = 1
        }
        delegate.setPoint(table_points)
    }
    
    
    func reDraw(_ table: [Float] ) {
        
        let width: Int = 50
        var temp_points = [CGPoint]()
        
        for (index, el) in table.enumerated() {
            if index == 0 { continue }
            if el == 1 {
                let y:Int = index / width
                let x:Int = index % width

                temp_points.append(CGPoint(x: x, y: y))
            }
        }
        
        self.points = temp_points
        setNeedsDisplay()
    }
    
    func clear() {
        self.points = []
        self.table_points = []
        setNeedsDisplay()
    }

}
