import Foundation
import UIKit

class DisplayWeatherHeaderView: UIView {

    // MARK: - UI Parameters

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet weak var clothesStackView: UIStackView!

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
