import SwiftUI
import SwiftData


struct HomeView: View {
    @Environment(\.modelContext) private var context
    @State private var isPresentingLogForm = false
    @Query(
        sort: [SortDescriptor(\MeasurementModel.date, order: .reverse)]
    ) var weightMeasurements: [MeasurementModel]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Weight Measurements")
                    .font(.headline)
                    .padding(.horizontal)

                if weightMeasurements.isEmpty {
                    Text("No weight measurements logged yet.")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                } else {
                    List {
                        ForEach(weightMeasurements.filter({ $0.type == .weight })) { measurement in
                            VStack(alignment: .leading) {
                                Text("\(measurement.value) lbs")
                                    .font(.body)
                                Text(measurement.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: deleteMeasurement)
                    }
                    .listStyle(PlainListStyle())
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingLogForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingLogForm) {
                LogMeasurementForm()
            }
        }
    }

    /// Deletes a measurement from SwiftData
    private func deleteMeasurement(at offsets: IndexSet) {
        for index in offsets {
            let measurement = weightMeasurements[index]
            context.delete(measurement)
        }
        do {
            try context.save()
        } catch {
            print("[HomeView] Error saving context after deletion: \(error.localizedDescription)")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
