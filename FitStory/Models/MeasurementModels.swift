import Foundation
import SwiftData


enum MeasurementType: String, Codable, CaseIterable {
    case weight
    case arms
    case waist
    case hims
    case chest
}

@Model
class MeasurementModel: Identifiable {
    var id: UUID
    var type: MeasurementType
    var value: String
    var date: Date
    var notes: String?

    init(type: MeasurementType = .weight, value: String = "", date: Date = Date(), notes: String? = nil) {
        self.id = UUID()
        self.type = type
        self.value = value
        self.date = date
        self.notes = notes
    }
}
