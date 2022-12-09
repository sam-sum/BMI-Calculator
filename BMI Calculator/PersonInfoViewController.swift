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

import UIKit

class PersonInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var genderSelection: UISegmentedControl!
    @IBOutlet weak var unitInUse: UISegmentedControl!
    @IBOutlet weak var viewImperial: UIView!
    @IBOutlet weak var viewMetric: UIView!
    
    @IBOutlet weak var heightMetersInput: UITextField!
    @IBOutlet weak var weightKgsInput: UITextField!
    @IBOutlet weak var heightFeetInput: UITextField!
    @IBOutlet weak var heightInchesInput: UITextField!
    @IBOutlet weak var weightPoundsInput: UITextField!
    
    @IBOutlet weak var lblYourBmi: UILabel!
    @IBOutlet weak var lblYouAre: UILabel!
    
    @IBOutlet weak var viewBmiGaugeNeedle: UIImageView!
    
    private var bmiProfile: BmiProfile!
    private var person: PersonInfo!
    private var personNew: PersonInfo!
    private var saveNeedleRadians: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bmiProfile = BmiProfile.sharedBmiProfile
        person = bmiProfile.getPersonInfo()
        personNew = person
        
        nameInput.delegate = self
        ageInput.delegate = self
        heightMetersInput.delegate = self
        weightKgsInput.delegate = self
        heightFeetInput.delegate = self
        heightInchesInput.delegate = self
        weightPoundsInput.delegate = self

        // Restore saved screen values
        nameInput.text = person.name
        ageInput.text = (person.age == 0) ? "" : String(person.age)
        genderSelection.selectedSegmentIndex = person.gender.rawValue
        unitInUse.selectedSegmentIndex = person.unit.rawValue
        heightMetersInput.text = (person.heightMeters == 0.0) ? "" : String(person.heightMeters)
        weightKgsInput.text = (person.weightKgs == 0.0) ? "" : String(person.weightKgs)
        heightFeetInput.text = (person.heightFeet == 0) ? "" : String(person.heightFeet)
        heightInchesInput.text = (person.heightInches == 0.0) ? "" : String(person.heightInches)
        weightPoundsInput.text = (person.weightPounds == 0.0) ? "" : String(person.weightPounds)
        
        // Handle the metric / imperial textfields
        if unitInUse.selectedSegmentIndex == 0 {
            // Metric unit
            viewMetric.isHidden = false
            viewImperial.isHidden = true
        } else {
            // Imperial unit
            viewMetric.isHidden = true
            viewImperial.isHidden = false
        }

        viewBmiGaugeNeedle.isHidden = true
        if person.heightMeters > 0 {
            refreshBmiResult()
        }
        
        // Dismiss the keyboard if the user tap outside the text field
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // *****
    // Refresh everything upon textfields changed
    // *****
    func textFieldDidEndEditing(_ textField: UITextField) {
        personNew = person
        if let newName = nameInput.text {
            personNew.name = newName
        }
        if let newAge = ageInput.text {
            personNew.age = Int(newAge) ?? 0
        }
        if unitInUse.selectedSegmentIndex == 0 {
            // Also convert input metric values to imperial values
            // Height
            if let newHeightMeters = heightMetersInput.text {
                personNew.heightMeters = Double(newHeightMeters) ?? 0.0
            }
            if let newWeightKgs = weightKgsInput.text {
                personNew.weightKgs = Double(newWeightKgs) ?? 0.0
            }
            (personNew.heightFeet, personNew.heightInches) = convertMetricHeight2Imperial(personNew.heightMeters)
            // Weight
            if let newWeightKgs = weightKgsInput.text {
                personNew.weightKgs = Double(newWeightKgs) ?? 0.0
            }
            person.weightPounds = convertMetricWeight2Imperial(personNew.weightKgs)
        } else {
            // Also convert input imperial values to metric
            // Height
            if let newHeightFeet = heightFeetInput.text {
                personNew.heightFeet = Int(newHeightFeet) ?? 0
            }
            if let newHeightInches = heightInchesInput.text {
                personNew.heightInches = Double(newHeightInches) ?? 0.0
            }
            personNew.heightMeters = convertImperialHeight2Metric(feet: personNew.heightFeet, inches: personNew.heightInches)
            // Weight
            if let newWeightPounds = weightPoundsInput.text {
                personNew.weightPounds = Double(newWeightPounds) ?? 0.0
            }
            personNew.weightKgs = convertImperialWeight2Metric(personNew.weightPounds)
        }
        
        if !(person == personNew) {
            person = personNew
            saveAllFields()
            refreshBmiResult()
        }
    }
    
    // *****
    // Hide the keyboard after the return key is clicked on the soft-keyboard
    // *****
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // *****
    // Handle segmented control for the gender selection
    // *****
    @IBAction func genderWasChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            person.gender = Gender.Male
        case 1:
            person.gender = Gender.Female
        default:
            person.gender = Gender.Other
        }
        saveAllFields()
    }
    
    // *****
    // Handle segmented control for the unit selection
    // *****
    @IBAction func unitWasChanged(_ sender: UISegmentedControl) {
        // Handle the metric / imperial textfields
        if sender.selectedSegmentIndex == 0 {
            // Metric unit
            viewMetric.isHidden = false
            viewImperial.isHidden = true
            person.unit = Unit.Metric
        } else {
            // Imperial unit
            viewMetric.isHidden = true
            viewImperial.isHidden = false
            person.unit = Unit.Imperial
        }
        saveAllFields()
    }
    
    // *****
    // Handle the reset button
    // *****
    @IBAction func resetWasPressed(_ sender: UIButton) {
        nameInput.text = ""
        ageInput.text = ""
        genderSelection.selectedSegmentIndex = 2    // Other gender
        unitInUse.selectedSegmentIndex = 0          // Metric
        heightMetersInput.text = ""
        weightKgsInput.text = ""
        heightFeetInput.text = ""
        heightInchesInput.text = ""
        weightPoundsInput.text = ""
        
        lblYourBmi.text = ""
        lblYouAre.text = "Your BMI result will be shown here."
        viewBmiGaugeNeedle.isHidden = true
        
        person = PersonInfo(name: "",
            age: 0,
            gender: Gender.Other,
            unit: Unit.Metric,
            weightKgs: 0.0,
            weightPounds: 0.0,
            heightMeters: 0.0,
            heightFeet: 0,
            heightInches: 0.0
        )
        personNew = person
        saveAllFields()
    }
    
    // *****
    // Handle the done button
    // *****
    @IBAction func doneWasPressed(_ sender: UIButton) {
        
    }

    // *****
    // Convert the metric height unit to imperial
    // *****
    private func convertMetricHeight2Imperial(_ metricHeight: Double) -> (Int, Double) {
        let meters = Measurement(value: metricHeight, unit: UnitLength.meters)
        let inches = meters.converted(to: .inches)
        let feet = Int(String(format: "%.0f", (inches.value / 12))) ?? 0
        let reminderInches: Double = inches.value - Double(feet * 12)
        return (feet, reminderInches)
    }
    
    // *****
    // Convert the metric weight unit to imperial
    // *****
    private func convertMetricWeight2Imperial(_ metricWeight: Double) -> Double {
        return metricWeight * 2.20462
    }
    
    // *****
    // Convert the imperial height unit to metric
    // *****
    private func convertImperialHeight2Metric(feet: Int, inches: Double) -> Double {
        let measureFeet = Measurement(value: Double(feet), unit: UnitLength.feet)
        let measureInches = Measurement(value: (measureFeet.value * 12 + inches), unit: UnitLength.inches)
        let metric = measureInches.converted(to: .meters)
        return metric.value
    }
    
    // *****
    // Convert the imperial weight unit to metric
    // *****
    private func convertImperialWeight2Metric(_ pounds: Double) -> Double {
        return pounds / 2.20462
    }
    
    // *****
    // Refresh the BMI output area
    // *****
    private func refreshBmiResult() {
        print("refreshBmiResult()")
        if person.heightMeters > 0 {
            let bmi = person.weightKgs / (person.heightMeters * person.heightMeters)
            let bmiFormatted = String(format: "%.1f", bmi)
            lblYourBmi.text = "Your BMI is \(bmiFormatted)"
            
            var adjustedBmi = bmi
            if adjustedBmi > 40 {
                adjustedBmi = 40
            } else if adjustedBmi < 16 {
                adjustedBmi = 16
            }
            
            let rotateRadians: Double = Double.pi * ((adjustedBmi - 16)/(40 - 16))
            
            switch bmi {
            case _ where bmi < 16:
                lblYouAre.text = "You are severe thinness"
            case _ where bmi >= 16 && bmi < 17:
                lblYouAre.text = "You are moderate thinness"
            case _ where bmi >= 17 && bmi < 18.5:
                lblYouAre.text = "You are mild thinness"
            case _ where bmi >= 18.5 && bmi < 25:
                lblYouAre.text = "You are normal"
            case _ where bmi >= 25 && bmi < 30:
                lblYouAre.text = "You are overweight"
            case _ where bmi >= 30 && bmi < 35:
                lblYouAre.text = "You are obese class I"
            case _ where bmi >= 35 && bmi < 40:
                lblYouAre.text = "You are obese class II"
            case _ where bmi >= 40:
                lblYouAre.text = "You are obese class III"
            default:
                lblYourBmi.text = ""
                lblYouAre.text = "Your BMI result will be shown here."
                viewBmiGaugeNeedle.isHidden = true
            }
            // Draw the gauge pointer with set zero
            viewBmiGaugeNeedle.isHidden = false
            viewBmiGaugeNeedle.transform = viewBmiGaugeNeedle.transform.rotated(by: CGFloat(saveNeedleRadians * -1))
            viewBmiGaugeNeedle.transform = viewBmiGaugeNeedle.transform.rotated(by: CGFloat(rotateRadians))
            saveNeedleRadians = rotateRadians
        } else {
            lblYourBmi.text = ""
            lblYouAre.text = "Your BMI result will be shown here."
            viewBmiGaugeNeedle.isHidden = true
        }
    }
    
    // *****
    // Save all screen values
    // *****
    private func saveAllFields() {
        print("saveAllFields()")
        bmiProfile.savePersonInfo(newPersonInfo: person)
    }
}
