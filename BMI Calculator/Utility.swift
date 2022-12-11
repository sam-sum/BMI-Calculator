//
//  MAPD714 F2022
//  Final Exam
//  BMI Calculator App
//
//  Developer: Sum, Chi Hung (Samuel) 300858503
//
//  Date: Dec 6, 2022
//  Version: 1.0import Foundation
import UIKit

class Utility {
    
    // *****
    // Convert hex color to UIColor
    // *****
    static func getUIColor(_ hex: String, alpha: Double = 1.0) -> UIColor? {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cleanString.hasPrefix("#")) {
            cleanString.remove(at: cleanString.startIndex)
        }

        if ((cleanString.count) != 6) {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleanString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // *****
    // Convert the metric height unit to imperial
    // *****
    static func convertMetricHeight2Imperial(_ metricHeight: Double) -> (Int, Double) {
        let meters = Measurement(value: metricHeight, unit: UnitLength.meters)
        let inches = meters.converted(to: .inches)
        let feet = Int(String(format: "%.0f", (inches.value / 12))) ?? 0
        let reminderInches: Double = round((inches.value - Double(feet * 12)) * 100) / 100.0
        return (feet, reminderInches)
    }
    
    // *****
    // Convert the metric weight unit to imperial
    // *****
    static func convertMetricWeight2Imperial(_ metricWeight: Double) -> Double {
        return round(metricWeight * 2.20462 * 100) / 100.0
    }
    
    // *****
    // Convert the imperial height unit to metric
    // *****
    static func convertImperialHeight2Metric(feet: Int, inches: Double) -> Double {
        let measureFeet = Measurement(value: Double(feet), unit: UnitLength.feet)
        let measureInches = Measurement(value: (measureFeet.value * 12 + inches), unit: UnitLength.inches)
        let metric = measureInches.converted(to: .meters)
        return round(metric.value * 100) / 100.0
    }
    
    // *****
    // Convert the imperial weight unit to metric
    // *****
    static func convertImperialWeight2Metric(_ pounds: Double) -> Double {
        return round(pounds / 2.20462 * 100) / 100.0
    }
    

}
