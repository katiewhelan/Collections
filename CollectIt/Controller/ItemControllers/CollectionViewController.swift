//
//  CollectionViewController.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 4/1/21.
//

import UIKit
import Foundation
import InstantSearch

class CollectionViewController: UIViewController {
    var searchResults = [Collection]()
    let keys = Keys()
    
    let alertService = AlertService()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addCollectionPressed(_ sender: UIBarButtonItem) {
        let alertVC = alertService.alert()
        present(alertVC, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "DisplayCell", bundle: nil), forCellReuseIdentifier: "DisplayCell")
        searchCollection(forText: "")
    }
    private var collectionIndex : Index!
    private var query = Query()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAlgoliaSearch()
        
    }
    
    private func setupAlgoliaSearch() {
        collectionIndex = keys.client.index(withName: "collection_search")
        query.hitsPerPage = 20
    }
    
    func searchCollection(forText searchString : String) {
        print("\(keys.firbaseUserId)")
        query.query = searchString
        query.filters = "userId: \(keys.firbaseUserId)"
        
        collectionIndex.search(query: query) { result in
            if case .success(let response) = result {
                do {
                let j : [Collection] = try response.extractHits()
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
   
extension CollectionViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = searchResults[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = (mainStoryboard.instantiateViewController(identifier: "itemViewListStoryboard") as? ItemListViewController)!
        vc.selectedCollection = collection
        vc.title = collection.title
        searchBar.endEditing(true)
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension CollectionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collection = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for : indexPath) as! DisplayCell
        cell.displayCellLabel.text = collection.title
        
        if let url = URL(string : collection.image ?? "") { //set up a default image in storage with a path to fill in
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

extension CollectionViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchCollection(forText: "")
        } else {
           
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text{
            searchCollection(forText: query)
        }
        searchBar.endEditing(true)
    }

}
