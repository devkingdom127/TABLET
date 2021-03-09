

import UIKit
import SDWebImage

class SearchPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userDefaults = UserDefaults.standard
    var historyFlag = false
    var arr_history = [String]()
    var restaurentForHistories = [EachRestaurent]()
    var selectedRestaurentInex_search : Int = 0
    var allRestaurents_search = [EachRestaurent]()
    var cityRestaurents_search = [EachRestaurent]()
    var selectedRestaurents_search = [EachRestaurent]()
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var recentLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var recentLabelLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentLabelHeight.constant = 0
        recentLabelLeading.constant = -500
                
        historyTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cityRestaurents_search = SharedManager.shared.cityRestaurents_share
        
        historyFlag = false
        recentLabelHeight.constant = 40
        recentLabelLeading.constant = 0
        
        searchbar.searchTextField.clearButtonMode = .never
        
        historyGet()
        
        
    }

    func filterContentForSearchText(_ searchName: String) {
        historyFlag = true
        recentLabelHeight.constant = 0
        recentLabelLeading.constant = -500
        let searchName1 = searchName.lowercased()
        selectedRestaurents_search = cityRestaurents_search.filter{ $0.restaurentName.lowercased().contains(searchName1) }
        historyTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRestaurents_search.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurentInex_search = indexPath.row
        self.performSegue(withIdentifier: "SearchToDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToDetail" {
            historySave()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell

        if let url = URL(string: baseFileURL + "\(selectedRestaurents_search[indexPath.item].restaurentLogo.replacingOccurrences(of: " ", with: "%20"))") {
            cell.restaurentImg.sd_setImage(with: url, placeholderImage: UIImage(named: "noImg"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    if( error != nil) {
                    print("Error while displaying image" , (error?.localizedDescription)! as String)
                    }
                })
        }
        else {
            let defaultImg: UIImage = UIImage(named: "noImg")!
            cell.restaurentImg.image = defaultImg
        }
        cell.restaurentName.text = selectedRestaurents_search[indexPath.row].restaurentName.uppercased()
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeBtnAction(sender:event:)), for: .touchUpInside)
        if historyFlag == false {
            cell.removeBtn.isHidden = false
        }
        else {
            cell.removeBtn.isHidden = true
        }

        historyTable.separatorColor = UIColor.clear
        return cell
    }
    @objc func removeBtnAction(sender:UIButton, event: Any)
    {
        let buttonRow = sender.tag
        let indexPath = IndexPath(item: buttonRow, section: 0)
        print(indexPath)
        let removeID = restaurentForHistories[indexPath.item].restaurentID
        for item in arr_history {
            if item.contains("\(removeID)") {
                arr_history.removeAll { $0 == item }
                userDefaults.setValue(arr_history, forKey: SharedManager.shared.cityInfo)
            }
        }
        historyFlag = false
        historyGet()
    }
    func historySave() {
        arr_history = userDefaults.stringArray(forKey: SharedManager.shared.cityInfo) ?? []
        for item in arr_history {
            if item.contains("\(selectedRestaurents_search[selectedRestaurentInex_search].restaurentID)") {
                arr_history.removeAll { $0 == item }
            }
        }
        if arr_history.count <= 20 {
            let historyTime = String(Date().millisecondsSince1970)
            arr_history.append("\(historyTime)" + "_" + "\(selectedRestaurents_search[selectedRestaurentInex_search].restaurentID)")
            userDefaults.setValue(arr_history, forKey: SharedManager.shared.cityInfo)
        }
        else {
            arr_history = arr_history.sorted(by: >)
            arr_history.removeLast()
            let historyTime = String(Date().millisecondsSince1970)
            arr_history.append("\(historyTime)" + "_" + "\(selectedRestaurents_search[selectedRestaurentInex_search].restaurentID)")
            userDefaults.setValue(arr_history, forKey: SharedManager.shared.cityInfo)
        }
        SharedManager.shared.preparing_eachRestaurentInfo = selectedRestaurents_search[selectedRestaurentInex_search]
    }
    func historyGet() {
        restaurentForHistories.removeAll()
        arr_history = userDefaults.stringArray(forKey: SharedManager.shared.cityInfo) ?? []
        arr_history = arr_history.sorted(by: >)
        for item in arr_history {
            let component =  item.components(separatedBy: "_")
            let restaurent_ID = component.last
            var restaurentForHistory : EachRestaurent!
            for restaurent in self.cityRestaurents_search {
                if restaurent.restaurentID == Int(restaurent_ID!) {
                    restaurentForHistory = restaurent
                    restaurentForHistories.append(restaurentForHistory)
                }
            }
        }
        selectedRestaurents_search = restaurentForHistories
        historyTable.reloadData()
    }
}


extension SearchPage: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text != "" {
            filterContentForSearchText(searchText)
        }
        else {
            historyFlag = false
            recentLabelHeight.constant = 40
            recentLabelLeading.constant = 0
            historyGet()
        }
    }
}

extension SearchPage: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.searchTextField.text = ""
        historyFlag = false
        searchbar.endEditing(true)
        historyGet()
    }
}
