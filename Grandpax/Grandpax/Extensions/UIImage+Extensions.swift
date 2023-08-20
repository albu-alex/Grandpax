//
//  UIImage+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 21.08.2023.
//

import UIKit

extension UIImage {
    class func drawRectangleOnImage(_ image: UIImage) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        image.draw(at: CGPoint.zero)

        let rectangle = CGRect(x: 0, y: (imageSize.height/2) - 30, width: imageSize.width, height: 60)

        UIColor.red.setFill()
        UIRectFill(rectangle)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
