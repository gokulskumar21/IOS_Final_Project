import UIKit
import CoreData
import CoreLocation

class InitialViewController: UITableViewController {
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?

    @IBOutlet var btn_add: UIBarButtonItem!
    
    @IBOutlet var searchBar: UISearchBar!
        
    var myFetchResultsController = CoreDataManager.shared.myFetchResultsController
    var dataList: [CityDb] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        tableView.delegate = self
        tableView.dataSource = self
        self.searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
   override func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1

   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
       return dataList.count
   }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clickecd on : \(indexPath.row)")
        let weatherViewController = storyboard?.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController
        weatherViewController?.city =
        dataList[indexPath.row].cityName ?? ""
       self.navigationController?.pushViewController(weatherViewController!, animated: true)
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("loaded :\(indexPath)")
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! initialTableViewCell
       cell.setData(model:dataList[indexPath.row])
    return cell
   }
   

   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {

           CoreDataManager.shared.deleteCity(city: dataList[indexPath.row])
            fetchAllCity()
           
       }
   }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 1
      }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        fetchAllCity()
        
    }
    
    func fetchAllCity() {
        dataList =   CoreDataManager.shared.fetchCityFromCoreData()
        
        tableView.reloadData()
    }



}

extension InitialViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}



extension InitialViewController : UISearchBarDelegate{
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == ""){
            
            dataList = CoreDataManager.shared.fetchCityFromCoreData()
            tableView.reloadData()
        }
        else {
            dataList =   CoreDataManager.shared.search(text: searchText)
            tableView.reloadData()
            return
        }
       
    }
    
}
