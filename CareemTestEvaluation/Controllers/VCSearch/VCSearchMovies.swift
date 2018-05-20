//
//  VCSearchMovies.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 16/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import UIKit

class VCSearchMovies: UIViewController {
    
    let webCollector = WebserviceCollections()
    var arrMovies = [Movies]()
    var arrSuggestion = [String]()
    var pageNo = 1
    var heightOfKeyborad : CGFloat = 0
    var isloadingData = false
    var isLoadMoreAvailable = true
    var searchString = ""
    var refreshController = UIRefreshControl()
    
    @IBOutlet weak var activityLoadMore: UIActivityIndicatorView!
    @IBOutlet weak var sbMovies: UISearchBar!
    @IBOutlet weak var tblMovieList: UITableView!
    @IBOutlet weak var tblSuggestion: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var heightSuggestionView: NSLayoutConstraint!
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSuggestion.tableFooterView = UIView()
        viewSearch.createCornerRadiusWithShadowWithColor(cornerRadius: 8, offset: .zero, opacity: 0.3, radius: 2, color: .black)
        refreshController.addTarget(self, action: #selector(pullToRefreshAction), for: .valueChanged)
        tblMovieList.addSubview(refreshController)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - KEYBOARD NOTIFIER
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        if #available(iOS 11.0, *) {
            heightOfKeyborad = keyboardFrame.cgRectValue.height + self.view.safeAreaInsets.bottom
        } else {
            heightOfKeyborad = keyboardFrame.cgRectValue.height
        }
    }
    
    //MARK: - SHOW ALERT WITH TITLE AND MESSAGE
    func showAlertWithTitleAndMessage( _ title : String, _ message: String){
        
        let alert = UIAlertController(title: title,  message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (isTrue) in
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - PULL TO REFESH ACTION
    //Reset result array and page number
    @objc func pullToRefreshAction(){
        if isConnectedToNetwork(){
            arrMovies.removeAll()
            tblMovieList.reloadData()
            pageNo = 1
            searchMovies(false)
        }
    }
    
    
    //MARK: - Search Movies
    /*Parameters
     @api_key - Static key provided to access API
     @query : Search String, cannot be blank
     @page : current Page index, page is started with 1 not 0
     */
    func searchMovies( _ isLoadMore : Bool){
        
        if isConnectedToNetwork(){
            activityLoadMore.startAnimating()
            if !isLoadMore {
                pageNo = 1
            }else{
                pageNo += 1
            }
            let param = ["api_key" : API_KEY,
                         "query" : searchString,
                         "page" : "\(pageNo)"]
            
            isloadingData = true
            webCollector.serachMovies(param: param) { result in
                self.isloadingData = false
                self.activityLoadMore.stopAnimating()
                switch result {
                case .success(let movieResult):
                    guard let movieResults = movieResult?.results else { return }
                    if movieResults.count == 0 && !isLoadMore{
                        self.showAlertWithTitleAndMessage("No Result found", "No result found matching your Serach")
                        return
                    }
                    self.arrMovies.append(contentsOf: movieResults)
                    self.tblMovieList.reloadData()
                    if movieResults.count < 10 {
                        self.isLoadMoreAvailable = false
                    }else{
                        self.isLoadMoreAvailable = true
                    }
                    if movieResults.count > 0 && self.pageNo == 1 && self.sbMovies.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0{
                        print(DatabaseManager.sharedDatabase.saveSearch(self.sbMovies.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
                    }
                case .failure(let error):
                    self.showAlertWithTitleAndMessage("Error", "\(error)")
                }
            }
        }else{
            activityLoadMore.stopAnimating()
            showAlertWithTitleAndMessage("No internet", "You are not connected to internet at the moment")
        }
    }
    
    //MARK: - SHOW AUTOSUGGESTION
    /*
     @Show Suggestion of last 10 Queries
     @Manage Height of the Suggestion Box based on height of View and Keyboard, must not be hidden by keyboard
     */
    func showAutoSuggest(){
        
        let arrSearch = DatabaseManager.sharedDatabase.getAllSearchResult(sbMovies.text! )
        if arrSearch.count == 0 {
            viewSearch.isHidden = true
        }else{
            viewSearch.isHidden = false
            arrSuggestion.removeAll()
            arrSuggestion.append(contentsOf: arrSearch)
            tblSuggestion.reloadData()
            let heightOftbl = CGFloat(arrSuggestion.count)*40.0
            var heighOfView =  view.frame.height - heightOfKeyborad - sbMovies.frame.height - 10
            if #available(iOS 11.0, *) {
                heighOfView = heighOfView - self.view.safeAreaInsets.top
            }
            if heightOftbl < heightSuggestionView.constant {
                heightSuggestionView.constant = heightOftbl
            }else{
                heightSuggestionView.constant = heighOfView
            }
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

//MARK:- UITABLEVIEW DATASOURCE
extension VCSearchMovies : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblMovieList {
            return arrMovies.count
        }else{
            return arrSuggestion.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblMovieList {
            return movieCell(tableView, indexPath)
        }else{
            return suggestionCell(tableView, indexPath)
        }
    }
    
    func movieCell( _ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tblCellMovies", for: indexPath) as? TBLCellMovies {
            let cellItem = arrMovies[indexPath.row]
            cell.lblMoviename.text = cellItem.original_title
            cell.lblMoviewDescription.text = cellItem.overview
            cell.lblReleaseDate.text = cellItem.release_date
            cell.lblMoviewDescription.sizeToFit()
            cell.imgMoviePoster.backgroundColor = randomColorWith(0.2)
            cell.imgMoviePoster.loadImageAsync(with: "\(IMAGE_BASEURL)\(IMAGE_PATH)w185\(cellItem.poster_path ?? "")")
            return cell
        }
        return UITableViewCell()
    }
    
    func suggestionCell( _ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAutocomplete", for: indexPath)
        cell.textLabel?.text = arrSuggestion[indexPath.row]
        return cell
    }
}

//MARK: - UITABLEVIEW DELEGATE
extension VCSearchMovies : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblSuggestion {
            sbMovies.text = arrSuggestion[indexPath.row]
            searchString = sbMovies.text ?? ""
            arrMovies.removeAll()
            tblMovieList.reloadData()
            pageNo = 1
            searchMovies(false)
            view.endEditing(true)
            viewSearch.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblSuggestion ||
            arrMovies.count == 0 ||
            !isLoadMoreAvailable || isloadingData { return }
        
        let lastElement = arrMovies.count - 1
        if indexPath.row == lastElement {
            activityLoadMore.startAnimating()
            searchMovies(true)
        }
    }
}

//MARK: - UISEARCHBAR DELEGATE
extension VCSearchMovies : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showAutoSuggest()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showAutoSuggest()
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewSearch.isHidden = true
        arrSuggestion.removeAll()
        tblSuggestion.reloadData()
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewSearch.isHidden = true
        arrSuggestion.removeAll()
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        view.endEditing(true)
        if searchBar.text?.count == 0{
            showAlertWithTitleAndMessage("No Search Value", "You must enter movie name to search")
        }else{
            arrMovies.removeAll()
            tblMovieList.reloadData()
            searchString = sbMovies.text ?? ""
            searchMovies(false)
        }
    }
}
