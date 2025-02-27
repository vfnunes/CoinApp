import Foundation

extension Double {
    func formatterToDollar() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
        numberFormatter.locale = Locale(identifier: "en_US")
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
