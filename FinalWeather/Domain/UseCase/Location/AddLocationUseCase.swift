import Foundation
import CoreLocation

protocol AddLocationUseCaseProtocol {
    func addLocation(cityName: String, coordinates: CLLocationCoordinate2D) throws -> Location
}

class AddLocationUseCase: AddLocationUseCaseProtocol {
    let repository: LocationRepositoryProtocol = LocationRepository()

    func addLocation(cityName: String, coordinates: CLLocationCoordinate2D) throws -> Location {
        let location = try repository.createLocation(cityName: cityName, coordinates: coordinates)
        return location
    }
}
