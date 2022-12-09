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

// *****
// Data structure for the BMI tracking
// *****
struct BmiItem: Codable {
    var id: String
    var measureDate: Date
    var weightKgs: Double
    var weightPounds: Double
    var bmi: Double
}

// *****
// Data structure for the BMI calculation
// *****
struct PersonInfo: Equatable, Codable {
    var name: String
    var age: Int
    var gender: Gender
    var unit: Unit
    var weightKgs: Double
    var weightPounds: Double
    var heightMeters: Double
    var heightFeet: Int
    var heightInches: Double
    
    static func == (lhs: PersonInfo, rhs: PersonInfo) -> Bool {
        return (
        lhs.name == rhs.name &&
        lhs.age == rhs.age &&
        lhs.gender == rhs.gender &&
        lhs.unit == rhs.unit &&
        lhs.weightKgs == rhs.weightKgs &&
        lhs.weightPounds == rhs.weightPounds &&
        lhs.heightMeters == rhs.heightMeters &&
        lhs.heightFeet == rhs.heightFeet &&
        lhs.heightInches == rhs.heightInches
        )
    }
}

// *****
// Data structure for the BMI tracking calculation
// *****
struct HeightInfo: Codable {
    var heightMeters: Double
    var heightFeet: Int
    var heightInches: Double
}

enum Gender: Int, Codable {
    case Male, Female, Other
}

enum Unit: Int, Codable {
    case Metric, Imperial
}

class BmiProfile {
    static let sharedBmiProfile = BmiProfile()
    
    private var personInfo: PersonInfo
    private var bmiItems: [BmiItem]
    private var heightInfo: HeightInfo

    init() {
        let defaults = UserDefaults.standard
        //restore the personal info
        personInfo = PersonInfo(name: "",
                      age: 0,
                      gender: Gender.Other,
                      unit: Unit.Metric,
                      weightKgs: 0.0,
                      weightPounds: 0.0,
                      heightMeters: 0.0,
                      heightFeet: 0,
                      heightInches: 0.0
        )
        if let data = defaults.value(forKey: "personInfo") as?  Data,
           let storedpersonInfo = try? JSONDecoder().decode(PersonInfo.self, from: data) {
            personInfo = storedpersonInfo
        }

        // retore the BMI items
        bmiItems = []
        if let data = defaults.value(forKey: "bmiItem") as?  Data,
           let storedBmiItems = try? JSONDecoder().decode([BmiItem].self, from: data) {
            bmiItems = storedBmiItems
        }
        
        // restore the height info
        heightInfo = HeightInfo(heightMeters: 0, heightFeet: 0, heightInches: 0)
        if let data = defaults.value(forKey: "heightInfo") as?  Data,
           let storedHeightInfo = try? JSONDecoder().decode(HeightInfo.self, from: data) {
            heightInfo = storedHeightInfo
        }
    }
    
    // *****
    // Return number of BMI tracking items
    func count() -> Int {
        return bmiItems.count
    }
    
    // *****
    // Return all values in an array
    // *****
    func getAllItems() -> [BmiItem] {
        return bmiItems
    }
    
    // *****
    // Return values of the person info
    // *****
    func getPersonInfo() -> PersonInfo {
        return personInfo
    }
    
    // *****
    // Return values of the height info
    // *****
    func getHeightInfo() -> HeightInfo {
        return heightInfo
    }
    
    // *****
    // Add an item into the list and sort the list in decending date order
    // *****
    func getAllBmiItems() -> [BmiItem] {
        return bmiItems
    }
    
    // *****
    // Add an item into the list and sort the list in decending date order
    // *****
    func addItem(_ item: BmiItem) {
        var newItem = item
        newItem.id = UUID().uuidString
        bmiItems.append(newItem)
        bmiItems = bmiItems.sorted(by: { $0.measureDate > $1.measureDate })
        saveBmiList()
    }
    
    // *****
    // Remove an item into the list and sort the list in decending date order
    // *****
    func removeItem(_ item: BmiItem) {
        bmiItems = bmiItems.filter {$0.id != item.id}
        bmiItems = bmiItems.sorted(by: { $0.measureDate > $1.measureDate })
        saveBmiList()
    }
    
    // *****
    // Replace an item in the list and sort the list in decending date order
    // *****
    func updateItem(_ item: BmiItem) {
        bmiItems = bmiItems.filter {$0.id != item.id}
        bmiItems.append(item)
        bmiItems = bmiItems.sorted(by: { $0.measureDate > $1.measureDate })
        saveBmiList()
    }

    // *****
    // Save the person info to the user default
    // *****
    func savePersonInfo(newPersonInfo: PersonInfo) {
        personInfo = newPersonInfo
        if let encoded = try? JSONEncoder().encode(personInfo) {
            let defaults = UserDefaults.standard
            defaults.setValue(encoded, forKey: "personInfo")
            defaults.synchronize()
        }
    }

    // *****
    // Save the height info to the user default
    // *****
    func saveHeightInfo(newHeightInfo: HeightInfo) {
        heightInfo = newHeightInfo
        if let encoded = try? JSONEncoder().encode(heightInfo) {
            let defaults = UserDefaults.standard
            defaults.setValue(encoded, forKey: "heightInfo")
            defaults.synchronize()
        }
    }
    
    // *****
    // Save the BMI tracking list to the user default
    // *****
    private func saveBmiList() {
        if let encoded = try? JSONEncoder().encode(bmiItems) {
            let defaults = UserDefaults.standard
            defaults.setValue(encoded, forKey: "bmiItems")
            defaults.synchronize()
        }
    }
}
