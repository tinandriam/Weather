import Foundation

protocol FetchLocationsUseCaseProtocol {
    func fetchLocations() throws -> [Location]
}

class FetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    let repository: LocationRepositoryProtocol = LocationRepository()

    func fetchLocations() throws -> [Location] {
        var locations: [Location] = []

        locations = try repository.fetchLocations()
        return locations
    }
}
