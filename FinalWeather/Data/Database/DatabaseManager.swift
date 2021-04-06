import Foundation
import CoreData

class DatabaseManager {
    static let shared = DatabaseManager()
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FinalWeather")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "FinalWeather", withExtension: "momd") else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

    public func newInMemoryContext() -> NSManagedObjectContext {
        guard let managedObjectModel = managedObjectModel else {
            return NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        }
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSInMemoryStoreType,
                configurationName: nil,
                at: nil,
                options: nil
            )
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = persistentStoreCoordinator
            return context
        } catch {
            return NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        }
    }
}
