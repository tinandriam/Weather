import Foundation
import UIKit
import CoreLocation
import CoreData

protocol LocationDataStoreProtocol {
    /// Create a location
    /// - Parameters:
    ///   - cityName: the name of the chosen city
    ///   - latitude: latitude of the chosen city
    ///   - longitude: longitude of the chosen city
    func createLocation(cityName: String, latitude: Double, longitude: Double) throws -> LocationEntity

    /// Fetch number of location entities in the database
    func fetchLocationsNumber() throws -> Int

    /// Sort location enities by their creation date
    func fetchLocationsByCreationDate() throws -> [LocationEntity]

    /// Fetch a location entity by the city name
    /// - Parameter:
    ///   - cityName: name of the city
    func fetchLocationBy(cityName: String) throws -> LocationEntity
}

class LocationDataStore: LocationDataStoreProtocol {

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = DatabaseManager.shared.viewContext) {
        self.context = context
    }

    func databaseIsEmpty() -> Bool {
        let entities = try? self.fetchLocationsByCreationDate()

        return entities?.count == 0 ? true : false
    }

    func createLocation(cityName: String, latitude: Double, longitude: Double) throws -> LocationEntity {

        if !self.databaseIsEmpty() {
            if let _ = try? self.fetchLocationBy(cityName: cityName) {
                throw DataStoreError.alreadyInDatabase
            }
        }

        let locationEntity = LocationEntity(context: context)

        locationEntity.cityName = cityName
        locationEntity.createdAt = Date()
        locationEntity.latitude = latitude
        locationEntity.longitude = longitude
        do {
            // save
            try context.save()
            return locationEntity
        } catch {
            context.rollback()
            throw DataStoreError.saveFailed(error)
        }
    }

    func fetchLocationsNumber() throws -> Int {
        var locationEntities: [LocationEntity] = []
        let locationsFetchRequest = NSFetchRequest<LocationEntity>(entityName: "LocationEntity")

        do {
            locationEntities = try context.fetch(locationsFetchRequest)
            return locationEntities.count
        } catch {
            throw DataStoreError.notFound
        }
    }

    func fetchLocationsByCreationDate() throws -> [LocationEntity] {
        var locationEntities: [LocationEntity] = []
        let locationsFetchRequest = LocationEntity.request()
        let sort = NSSortDescriptor(key: #keyPath(LocationEntity.createdAt), ascending: false)
        locationsFetchRequest.sortDescriptors = [sort]
        do {
            locationEntities = try context.fetch(locationsFetchRequest)
            return locationEntities
        } catch {
            throw DataStoreError.notFound
        }
    }

    func fetchLocationBy(cityName: String) throws -> LocationEntity {
        let locationFetchRequest = NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
        locationFetchRequest.fetchLimit = 1
        locationFetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
        do {
            if let locationEntity = try context.fetch(locationFetchRequest).first {
                return locationEntity
            }
            throw DataStoreError.notFound
        } catch {
            throw error
        }
    }
}
