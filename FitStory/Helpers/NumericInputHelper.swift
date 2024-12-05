import Foundation

struct NumericInputHelper {
    /// Validates and formats a numeric input string.
    /// - Parameters:
    ///   - input: The raw input string.
    ///   - maxDecimalPlaces: The maximum number of decimal places allowed (default is 2).
    /// - Returns: A validated and formatted string containing only valid numeric input.
    static func formatInput(_ input: String, maxDecimalPlaces: Int = 2) -> String {
        let filtered = input.filter { "0123456789.".contains($0) }
        let components = filtered.split(separator: ".")
        
        if components.count > 2 {
            // More than one decimal point: Keep only the first two components
            return String(components[0]) + "." + String(components[1])
        } else if components.count == 2, components[1].count > maxDecimalPlaces {
            // Limit decimal places
            return String(components[0]) + "." + String(components[1].prefix(maxDecimalPlaces))
        } else {
            // Valid input as is
            return filtered
        }
    }
}
