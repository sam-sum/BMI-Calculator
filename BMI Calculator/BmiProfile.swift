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

struct BmiItem: Codable {
    var id: String
    var measureDate: Date
    var weight: Double
    var bmi: Double
}

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

        // retore the BMI item array
        bmiItems = []
        if let data = defaults.value(forKey: "bmiItem") as?  Data,
           let storedBmiItems = try? JSONDecoder().decode([BmiItem].self, from: data) {
            bmiItems = storedBmiItems
        }
    }
    
    // *****
    // Return number of items in the dictionary
    // *****
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
    // Save the person info
    // *****
    func savePersonInfo(newPersonInfo: PersonInfo) {
        // create a new item with an unique id
        personInfo = newPersonInfo
        if let encoded = try? JSONEncoder().encode(personInfo) {
            let defaults = UserDefaults.standard
            defaults.setValue(encoded, forKey: "personInfo")
            defaults.synchronize()
        }
    }
}
