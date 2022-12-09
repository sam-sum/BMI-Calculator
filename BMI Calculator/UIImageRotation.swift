//
//  MAPD714 F2022
//  Final Exam
//  BMI Calculator App
//
//  Developer: Sum, Chi Hung (Samuel) 300858503
//
//  Date: Dec 6, 2022
//  Version: 1.0
//

import Foundation
import UIKit

extension UIImage {
    func rotate(radians: Double) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle-lower
        context.translateBy(x: newSize.width * 0.5, y: newSize.height * 0.9)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its origin
        self.draw(in: CGRect(x: -self.size.width * 0.5, y: -self.size.height * 0.9, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
