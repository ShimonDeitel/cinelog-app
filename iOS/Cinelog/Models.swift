import Foundation

struct MovieEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var title: String
    var rating: Int
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), title: String = "", rating: Int = 0, notes: String = "") {
        self.id = id
        self.date = date
        self.title = title
        self.rating = rating
        self.notes = notes
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var metricUnits: Bool = false
    var includeInStreak: Bool = true
}
