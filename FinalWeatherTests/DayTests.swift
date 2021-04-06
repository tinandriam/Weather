import XCTest
@testable import FinalWeather

class DayTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testToday() {
        // Given a location entity having a day entity which is today
        let context = DatabaseManager.shared.newInMemoryContext()
        let location = LocationEntity(context: context)
        let day = DayEntity(context: context)
        day.date = Date()
        day.location = location

        // When creating location model
        let model = Location(locationEntity: location)

        // Then model.today should be today
        XCTAssertEqual(model.today, Day(dayEntity: day))

    }

}
