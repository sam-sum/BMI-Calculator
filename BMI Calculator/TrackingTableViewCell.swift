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

class TrackingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblBmi: UILabel!
    
    private var tagRow: Int = 0
    static let identifier = "TrackingTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TrackingTableViewCell", bundle: nil)
    }
    
    // *****
    // Config the content of a table cell
    // *****
    func configure(with item: BmiItem, row: Int, unit: Unit) {
        self.tagRow = row
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        lblDate.text = dateFormatterPrint.string(from: item.measureDate)
        if unit == Unit.Metric {
            lblWeight.text = String(format: "%.2f", item.weightKgs)
        } else {
            lblWeight.text = String(format: "%.2f", item.weightPounds)
        }
        lblBmi.text = String(format: "%.1f", item.bmi)
        if row % 2 == 0 {
            backgroundColor = UIColor.white
            lblDate.textColor = Utility.getUIColor("#F07D0A")
            lblWeight.textColor = Utility.getUIColor("#F07D0A")
            lblBmi.textColor = Utility.getUIColor("#F07D0A")
        } else {
            backgroundColor = Utility.getUIColor("#F07D0A")
            lblDate.textColor = UIColor.white
            lblWeight.textColor = UIColor.white
            lblBmi.textColor = UIColor.white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
