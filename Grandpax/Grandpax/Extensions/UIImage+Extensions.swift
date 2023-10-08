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
        
        for point in points {
            let pointRect = CGRect(x: point.x - 1.0, y: point.y - 1.0, width: 2.0, height: 2.0)
            Theme.tintColor.setFill()
            
            UIRectFill(pointRect)
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }

}
