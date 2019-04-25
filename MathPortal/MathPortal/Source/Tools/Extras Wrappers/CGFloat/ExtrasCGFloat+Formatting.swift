
import UIKit

extension CGFloatExtras {

    func format(digits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        formatter.minimumIntegerDigits = 1
        return formatter.string(from: NSNumber(value: Double(value))) ?? String(Double(value))
    }
    
}
