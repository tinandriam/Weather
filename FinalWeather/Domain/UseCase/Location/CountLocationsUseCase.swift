import Foundation

protocol CountLocationsUseCaseProtocol {
    func fetchLocationNumber() throws -> Int
}

class CountLocationsUseCase: CountLocationsUseCaseProtocol {
    let repository: LocationRepositoryProtocol = LocationRepository()

    func fetchLocationNumber() throws -> Int {
        return try repository.fetchLocationsNumber()
    }
}
