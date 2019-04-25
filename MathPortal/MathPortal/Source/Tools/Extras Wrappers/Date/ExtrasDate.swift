import UIKit

extension Date {
    
    /// Used for static access. The lowercase is by design so you call UIView.extras.func
    typealias extras = DateExtras
    
    var extras: DateExtras {
        return DateExtras(date: self)
    }
    
}

class DateExtras {

    var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
}
