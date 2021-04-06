import Foundation
import UIKit

class CurrentWeatherInfosView: UIView {

    // MARK: - UI Parameters

    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!

    @IBAction func changeLocationButton(_ sender: Any) {
        self.tapButton()
    }

    // MARK: - Parameters

    var tapButton = ({ () -> Void in })

    // MARK: - Functions

    static func loadFromNib() -> CurrentWeatherInfosView {
        guard let view = Bundle.main.loadNibNamed(
                "CurrentWeatherInfosView",
                owner: self,
                options: nil
        )?.first as? CurrentWeatherInfosView else {
          fatalError()
        }
        return view
    }
}
