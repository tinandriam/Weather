import Foundation
import UIKit

class DisplayForecastWeatherCell: UITableViewCell {

    // MARK: - UIParameters

    @IBOutlet weak var forecastWeatherIconImageView: UIImageView!
    @IBOutlet weak var forecastedDayLabel: UILabel!
    @IBOutlet weak var forecastedTemperatureLabel: UILabel!

    // MARK: - Functions

    static func loadFromNib() -> DisplayWeatherHeaderView {
        guard let view = Bundle.main.loadNibNamed(
                "DisplayWeatherHeaderView",
                owner: self,
                options: nil
        )?.first as? DisplayWeatherHeaderView else {
          fatalError()
        }
        return view
    }
}
