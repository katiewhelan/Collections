//
//  SearchViewController.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 3/24/21.
//

import UIKit
import Foundation
import InstantSearch

class SearchViewController : UIViewController{
    var searchResults = [Item]()
    let keys = Keys()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "DisplayCell", bundle: nil), forCellReuseIdentifier: "DisplayCell")
    }
    private var collectionIndex : Index!
    private var query = Query()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAlgoliaSearch()
    }
    
    private func setupAlgoliaSearch() {
        collectionIndex = keys.client.index(withName: "item_search")
        query.hitsPerPage = 20
    }
    
    func searchAllItems(forText searchString : String) {
        query.query = searchString
        query.filters = "userId: \(keys.firbaseUserId)"

        collectionIndex.search(query: query) { result in
            if case .success(let response) = result {
              //  print("respnse \(response)")
                do {
                    let j : [Item] = try response.extractHits()
                    self.searchResults = j
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print("ERROR with collection")
                }
            }
        }
    }
}

extension SearchViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = searchResults[indexPath.row]
        let itemStoryboard = UIStoryboard(name: "Item", bundle: nil)
        let vc = (itemStoryboard.instantiateViewController(identifier: "Item") as? ItemController)!
        vc.originalItem = item
        searchBar.endEditing(true)
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for : indexPath) as! DisplayCell
        cell.displayCellImage.image = UIImage(named : "placeHolder")
        cell.displayCellLabel.text = item.title
        cell.DisplayLabelSub.text = item.type
        if let url = URL(string : item.image ?? "") { //set up a default image in storage with a path to fill in
            let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    if let downLoadImage = UIImage(data: data){
                        cell.displayCellImage.image = downLoadImage
                    }
                }
            })
            task.resume()
        }
        return cell
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchAllItems(forText: "")
        }else {
            searchAllItems(forText: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
