

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController  {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentButton: UIButton!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        searchTextField.delegate = self
        weatherManager.delegate = self
        //bắt buộc phải cho deleagte vào trong này mới đúng
    }

    @IBAction func comeBackToCurrent(_ sender: UIButton) {
        //weatherManager.fetchWeather(lat: latitude, lon: longitude)
        locationManager.requestLocation()
    }
    
}


// MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }
        else
        {
            textField.placeholder = "Type something here"
            return false
        }
    }
     
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text
        {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
     
}
// MARK: - WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temparatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        // cú pháp để tránh bị frozen code và sập, chỉ cập nhật thông tin ở luồng chính còn các luồng khác lấy in4 bình thường
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            weatherManager.fetchWeather(lat: latitude, lon: longitude)
            //print(latitude)
           // print(longitude)
        }
    }
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error)
    }
}

















// dùng delegate để use hàm nơi khác
// bước 1: tạo protocol
// ex
//protocol WeatherManagerDelegate
//{
   // func didUpdateWeather(weather: WeatherModel)
//}
// bước 2: tạo biến delegate (vietsub là đại diện) chứ đặt tên khác cx ok
// biến delegate ở nơi cần kích hoạt là có thuộc tính là protocol
// delegate : Protocol
// bước 3: ở cái class mình cần lấy kích hoạt / lấy thuộc tính đó ta cần cho nó kế thừa protocol
// ex WeatherViewController : WeatherManagerDelegate
// bước 4: tạo biến có thuộc tính (kiểu struct class ý) mà trong thuộc tính đó chứa delegare cần dùng
// ví dụ : var weatherManager = WeatherManager() bởi mình đang tạo delegate trong WeatherManager
// bước 5: gắn biến deleagate = self ( chính xác là self chỉ class mình đang ở và cái cần lấy, có thể lấy cái khác cx ok nếu mình cần lấy ở cái khác) , còn delegate là đại diện, tức là mình cho cái self này đại diện cho cái WeatherManager làm việc ( khó tả v lấy tạm tên vậy)
// ex weatherManager.delegate = self
// note quan trọng là dòng bước 5 chỉ dùng được trong func viewDidLoad()
// bước 6: tạo hàm cần dùng trong cái mình muốn uỷ quyền làm thay WeatherViewController (khó tả quá lấy tên bài này làm đại diện)
// chú ý phải trùng tên với hàm trong protocol
// ex
//func didUpdateWeather(weather: WeatherModel) {
//print(weather.temparature)
//}
