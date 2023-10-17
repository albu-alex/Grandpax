//
//  UIImage+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 21.08.2023.
//

import UIKit

extension UIImage {
    class func drawPointsOnImage(_ image: UIImage, points: [CGPoint]) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0

        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        image.draw(at: CGPoint.zero)
        let path = UIBezierPath()
        path.lineWidth = 2.0
        Theme.tintColor.setStroke()

        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.stroke()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
