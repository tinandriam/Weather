import Foundation

protocol FetchLocationByNameUseCaseProtocol {
    func fetchLocationBy(cityName: String) throws -> Location
}

class FetchLocationByNameUseCase: FetchLocationByNameUseCaseProtocol {
    let repository: LocationRepositoryProtocol = LocationRepository()

    func fetchLocationBy(cityName: String) throws -> Location {
        let location = try repository.fetchLocationBy(cityName: cityName)
        return location
    }
}
