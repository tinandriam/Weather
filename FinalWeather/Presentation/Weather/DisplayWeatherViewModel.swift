import Foundation
import CoreLocation
import Combine

class DisplayWeatherViewModel {

    // MARK: - Parameters

    let fetchLocationUseCase: FetchLocationsUseCaseProtocol = FetchLocationsUseCase()
    var location = CurrentValueSubject<Location?, Never>(nil)
    var locationsList: [Location]?
    var bag: Set<AnyCancellable> = []

    var today: Day? {
        return location.value?.today
    }

    var forecast: [Day]? {
        return location.value?.forecast
    }

    lazy var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    // MARK: - Initilizer

    init() {
        self.setLocations()
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange).sink { (_) in
            self.setLocations()
        }.store(in: &bag)
    }

    // MARK: - Functions

    func setLocations() {
        let locations = try? fetchLocationUseCase.fetchLocations()

        self.locationsList = locations
        self.location.value = locations?.first
    }

    func weekdayFromDate(date: Date) -> String {
        return weekdayFormatter.string(from: date)
    }
}
