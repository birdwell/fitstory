import SwiftUI
import SwiftData

struct LogMeasurementForm: View {
    @State private var measurement = MeasurementModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Measurement Type")) {
                    Picker("Type", selection: $measurement.type) {
                        ForEach(MeasurementType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Measurement Value")) {
                    HStack {
                        TextField("Enter value", text: $measurement.value)
                            .keyboardType(.decimalPad)
                            .onChange(of: measurement.value) { _, newValue in
                                measurement.value = NumericInputHelper.formatInput(newValue)
                            }
                        Text(unitForMeasurementType(measurement.type))
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $measurement.date, displayedComponents: .date)
                }

                Section(header: Text("Notes (Optional)")) {
                    TextField(
                        "Add notes here",
                        text: Binding(
                            get: { measurement.notes ?? "" },
                            set: { measurement.notes = $0.isEmpty ? nil : $0 }
                        )
                    )
                }
            }
            .navigationTitle("Log Measurement")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMeasurement()
                        dismiss()
                    }
                    .disabled(measurement.value.isEmpty)
                }
            }
        }
    }

    func unitForMeasurementType(_ type: MeasurementType) -> String {
        switch type {
        case .weight: return "lbs"
        case .arms, .waist, .hims, .chest: return "inches"
        }
    }

    func saveMeasurement() {
        do {
            try MeasurementService(context: context).saveMeasurement(measurement)
            print("[LogMeasurementForm] Measurement saved successfully.")
        } catch {
            print("[LogMeasurementForm] Error saving measurement: \(error.localizedDescription)")
        }
    }
}
