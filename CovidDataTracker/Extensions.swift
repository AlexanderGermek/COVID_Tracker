//
//  Extensions.swift
//  MySpotify
//
//  Created by iMac on 15.05.2021.
//

import UIKit
import Charts

class ChartValueFormatter: NSObject, IValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?

    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: value)!
    }
}

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}


extension DateFormatter {
    
    static let simpleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YY HH:mm"//"YYYY-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    static let isoDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    static let graphDecodeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static let graphEncodeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter
    }()
}


extension NumberFormatter {
    
    static let decimalNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        formatter.locale = .current
        return formatter
    }()
}

extension Int {
    func getKString() -> String {

        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1_000_000
        let billion = number / 1_000_000_000
        
        if billion >= 1.0 {
            
            let a = Int(round(billion*10)/10) //Int для получения целого числа без точки
            return "\(a)B"
            
        } else if million >= 1.0 {
            
            let a = Int(round(million*10)/10)
            return "\(a)M"
            
        } else if thousand >= 1.0 {
            
            let a = Int(round(thousand*10/10))
            return ("\(a)K")
        } else {
            return "\(Int(number))"
        }
    }
}


//extension String {
//    static func formattedDate(string: String) -> String {
//
//        guard let date = DateFormatter.dateFormatter.date(from: string) else {
//            return string
//        }
//
//        return DateFormatter.displayDateFormatter.string(from: date)
//    }
//}


//extension Notification.Name {
//    static let albumSavedNotification = Notification.Name("albumSavedNotification")
//}
