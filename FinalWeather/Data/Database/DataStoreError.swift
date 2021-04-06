import Foundation

enum DataStoreError: Error {
    case saveFailed(Error)
    case notFound
    case alreadyInDatabase
}
