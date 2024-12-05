import SwiftData
import Foundation

class MeasurementService {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Save a new measurement
    func saveMeasurement(_ measurement: MeasurementModel) throws {
        context.insert(measurement)
        try context.save()
        print("[MeasurementService] Measurement saved: \(measurement.type.rawValue), \(measurement.value)")
    }

    /// Fetch all measurements of a specific type
    func fetchMeasurements(of type: MeasurementType) -> [MeasurementModel] {
        let fetchDescriptor = FetchDescriptor<MeasurementModel>(
            predicate: #Predicate { $0.type == type },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        let results = (try? context.fetch(fetchDescriptor)) ?? []
        print("[MeasurementService] Fetched \(results.count) measurements of type: \(type.rawValue)")
        return results
    }

    /// Fetch the last N measurements of a specific type
    func fetchLastMeasurements(of type: MeasurementType, limit: Int) -> [MeasurementModel] {
        var fetchDescriptor = FetchDescriptor<MeasurementModel>(
            predicate: #Predicate { $0.type == type },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        fetchDescriptor.fetchLimit = limit

        let results = (try? context.fetch(fetchDescriptor)) ?? []
        print("[MeasurementService] Fetched last \(results.count) measurements of type: \(type.rawValue)")
        return results
    }
}
