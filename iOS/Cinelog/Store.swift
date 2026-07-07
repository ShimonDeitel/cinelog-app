import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeTierLimit = 15

    @Published var entries: [MovieEntry] = []
    @Published var settings: AppSettings = AppSettings()
    @Published var isPro: Bool = false

    private let entriesURL: URL
    private let settingsURL: URL

    init() {
        let dir = Store.appSupportDirectory()
        entriesURL = dir.appendingPathComponent("entries.json")
        settingsURL = dir.appendingPathComponent("settings.json")
        load()
        if entries.isEmpty {
            entries = Store.seedData()
            save()
        }
    }

    static func appSupportDirectory() -> URL {
        let fm = FileManager.default
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("Cinelog", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    static func seedData() -> [MovieEntry] {
        [
        MovieEntry(date: Calendar.current.date(byAdding: .day, value: -0, to: Date()) ?? Date(), title: "Sample 1", rating: 1, notes: "Sample 1", notes: ""),
        MovieEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), title: "Sample 2", rating: 2, notes: "Sample 2", notes: ""),
        MovieEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), title: "Sample 3", rating: 3, notes: "Sample 3", notes: ""),
        MovieEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), title: "Sample 4", rating: 4, notes: "Sample 4", notes: ""),
        MovieEntry(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), title: "Sample 5", rating: 5, notes: "Sample 5", notes: "")
        ]
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeTierLimit
    }

    @discardableResult
    func add(_ entry: MovieEntry) -> Bool {
        guard canAddMore else { return false }
        entries.insert(entry, at: 0)
        save()
        return true
    }

    func update(_ entry: MovieEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: MovieEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        let fm = FileManager.default
        if fm.fileExists(atPath: entriesURL.path),
           let data = try? Data(contentsOf: entriesURL),
           let decoded = try? JSONDecoder().decode([MovieEntry].self, from: data) {
            entries = decoded
        }
        if fm.fileExists(atPath: settingsURL.path),
           let data = try? Data(contentsOf: settingsURL),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: entriesURL, options: .atomic)
        }
        if let data = try? JSONEncoder().encode(settings) {
            try? data.write(to: settingsURL, options: .atomic)
        }
    }
}
