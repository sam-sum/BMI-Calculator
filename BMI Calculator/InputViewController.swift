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


protocol InputViewControllerDelegate: AnyObject {
    func inputViewControllerDidFinish()
}

class InputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    
    weak var delegate: InputViewControllerDelegate?
    
    private var bmiProfile: BmiProfile!
    private var heightInfo: HeightInfo!
    private var isAddMode: Bool = false
    var editingItem: BmiItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightInput.delegate = self
        // Retrieve the user default values
        bmiProfile = BmiProfile.sharedBmiProfile
        heightInfo = bmiProfile.getHeightInfo()
        // Fill up the initial values according to add or edit mode
        if editingItem == nil {
            //add mode
            isAddMode = true
            lblTitle.text = "Add a new entry"
            editingItem = BmiItem(
                id: "",
                measureDate: Date(),
                weightKgs: 0.0,
                weightPounds: 0.0,
                bmi: 0.0)
        } else {
            //edit mode
            isAddMode = false
            lblTitle.text = "Edit a row"
            datePicker.date = editingItem!.measureDate
            if bmiProfile.getPersonInfo().unit == Unit.Metric {
                if let weight = editingItem?.weightKgs {
                    weightInput.text = String(weight)
                }
            } else {
                if let weight = editingItem?.weightPounds {
                    weightInput.text = String(weight)
                }
            }
        }
        if bmiProfile.getPersonInfo().unit == Unit.Metric {
            lblWeight.text = "Weight (Kgs)"
        } else {
            lblWeight.text = "Weight (Lbs)"
        }
        // Add target to the datepicker
        self.datePicker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        // Dismiss the keyboard if the user tap outside the text field
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // *****
    // Save the weight input to both metric and imperial variables
    // *****
    func textFieldDidEndEditing(_ textField: UITextField) {
        if bmiProfile.getPersonInfo().unit == Unit.Metric {
            if let newWeight = weightInput.text {
                editingItem?.weightKgs = Double(newWeight) ?? 0.0
                editingItem?.weightPounds = Utility.convertMetricWeight2Imperial(Double(newWeight) ?? 0.0)
            }
        } else {
            // Handle the imperial input
            if let newWeight = weightInput.text {
                editingItem?.weightPounds = Double(newWeight) ?? 0.0
                editingItem?.weightKgs = Utility.convertImperialWeight2Metric(Double(newWeight) ?? 0.0)
            }
        }
        // Refresh BMI
        let bmi = (editingItem?.weightKgs ?? 0.0) / (heightInfo.heightMeters * heightInfo.heightMeters)
        editingItem?.bmi = round(bmi * 10) / 10
    }
    
    // *****
    // Hide the keyboard after the return key is clicked on the soft-keyboard
    // *****
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // *****
    // Action to handle the date picker changes
    // *****
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        editingItem?.measureDate = datePicker.date
    }
    
    // *****
    // Action to handle the save button
    // *****
    @IBAction func saveDidPressed(_ sender: UIButton) {
        let saveAlert = UIAlertController(title: "Save", message: "Confirm to save the input data?", preferredStyle: UIAlertController.Style.alert)
        saveAlert.view.tintColor = Utility.getUIColor("#F07D0A")
        
        saveAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("save alert OK pressed")
            if self.isAddMode {
                self.bmiProfile.addItem(self.editingItem!)
            } else {
                self.bmiProfile.updateItem(self.editingItem!)
            }
            self.dismiss(animated: true, completion: {() in print("input dismissed");self.delegate?.inputViewControllerDidFinish()})
            
        }))

        saveAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Update alert CANCEL pressed")
        }))

        present(saveAlert, animated: true, completion: nil)
    }
    
    // *****
    // Action to handle the cancel button
    // *****
    @IBAction func cancelDidPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
/*
extension InputViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("InputViewController, presentationControllerDidDismiss called")
        self.delegate?.InputViewControllerDidFinish(self)
    }
}
*/
