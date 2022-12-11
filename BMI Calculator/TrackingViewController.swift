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

class TrackingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var table: UITableView!
    
    private var bmiProfile: BmiProfile!
    private var bmiItems: [BmiItem]!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init table view and cells
        table.register(TrackingTableViewCell.nib(), forCellReuseIdentifier: TrackingTableViewCell.identifier)
        table.dataSource = self
        table.rowHeight = 60
        // Prepare the long press gesture
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        longPressGesture.delegate = self
        self.table.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Retrieve the user default values
        initalizeValues()
    }

    func initalizeValues() {
        bmiProfile = BmiProfile.sharedBmiProfile
        bmiItems = bmiProfile.getAllBmiItems()
        print("TrackingViewController, bmiItems: \(bmiItems.count)")
        
        if bmiProfile.getPersonInfo().unit == Unit.Metric {
            lblWeight.text = "Weight (Kgs)"
        } else {
            lblWeight.text = "Weight (Lbs)"
        }
        table.reloadData()
    }
    
    // *****
    // define number of total cells (row) in the table view
    // *****
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bmiItems.count
    }
    
    // *****
    // Called by iOS to reuse / create a table cell for display
    // *****
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackingTableViewCell.identifier, for: indexPath) as! TrackingTableViewCell
        cell.configure(with: bmiItems[indexPath.row], row: indexPath.row, unit: bmiProfile.getPersonInfo().unit)
        return cell
    }
    
    // *****
    // Additional function sets the table view cell be editable
    // *****
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // *****
    // Called by iOS when the table cell is swipped left for deletion
    // *****
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteItem = self.bmiItems[indexPath.row]
            self.bmiProfile.removeItem(deleteItem)
            bmiItems = bmiProfile.getAllBmiItems()
            
            if self.bmiProfile.count() == 0 {
                if let myTabBarController = tabBarController {
                    myTabBarController.selectedIndex = 0
                }
            } else {
                table.deleteRows(at: [indexPath], with: .fade)
                table.reloadData()
            }
        }
    }

    // *****
    // Handles the long press event
    // *****
    @objc func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("long press detected")
            let touchPoint = sender.location(in: self.table)
            if let indexPath = table.indexPathForRow(at: touchPoint) {
                print(indexPath.row)
                self.editRow(with: indexPath.row)
            }
        }
    }
    
    // *****
    // Show the input screen with a row item passed to it for editing
    // *****
    func editRow(with tag: Int) {
        print ("Editing row: \(tag)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InputScreen") as! InputViewController
        vc.editingItem = bmiItems[tag]
        vc.isModalInPresentation = true
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    // *****
    // Show the input screen with a nil item passed to it for adding
    // *****
    @IBAction func addDidPressed(_ sender: UIButton) {
        print ("Add a row")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InputScreen") as! InputViewController
        vc.editingItem = nil
        vc.isModalInPresentation = true
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

// *****
// Triggered after the input screen is dismissed to refresh tha table view
// *****
extension TrackingViewController: InputViewControllerDelegate {
    func inputViewControllerDidFinish() {
        print("InputViewControllerDidFinish called")
        initalizeValues()
    }
}
