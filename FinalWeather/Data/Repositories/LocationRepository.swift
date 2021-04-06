import Foundation
import CoreLocation

protocol LocationRepositoryProtocol {
    func createLocation(cityName: String, coordinates: CLLocationCoordinate2D) throws -> Location
    func fetchLocationsNumber() throws -> Int
    func fetchLocations() throws -> [Location]
    func fetchLocationBy(cityName: String) throws -> Location
}

class LocationRepository: LocationRepositoryProtocol {

    let locationDataStore: LocationDataStoreProtocol = LocationDataStore()

    func createLocation(cityName: String, coordinates: CLLocationCoordinate2D) throws -> Location {

        let location = try locationDataStore.createLocation(
            cityName: cityName,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
        return Location(locationEntity: location)
    }

    func fetchLocationsNumber() throws -> Int {
        return try locationDataStore.fetchLocationsNumber()
    }

    func fetchLocations() throws -> [Location] {
        let fetchedLocations = try locationDataStore.fetchLocationsByCreationDate()
        var locations: [Location] = []

        for loc in fetchedLocations {
            locations.append(Location(locationEntity: loc))
        }
        return locations
    }

    func fetchLocationBy(cityName: String) throws -> Location {
        let location = try locationDataStore.fetchLocationBy(cityName: cityName)
        return Location(locationEntity: location)
    }
}
