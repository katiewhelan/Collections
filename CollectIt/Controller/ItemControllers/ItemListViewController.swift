
//  ItemViewController.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 2/24/21.


import UIKit
import Firebase
import InstantSearch

class ItemListViewController: UIViewController  {
  var collectionList = [Item]()
    let keys = Keys()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCollection : Collection?
    
    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "DisplayCell", bundle: nil), forCellReuseIdentifier: "DisplayCell")
        collectionIndex = keys.client.index(withName: "item_search")
        itemSearchByCollection(forText: "")
        
   
        
        if let title = selectedCollection?.title {
            searchBar.placeholder = "Search \(title) Collection"
        } else {
            searchBar.placeholder = "Search Collection"
        }
    }
    
    private var collectionIndex : Index!
    private var query = Query()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAlgoliaSearch()
    }
    
    @objc func addTapped() {
            let itemStoryboard = UIStoryboard(name: "Item", bundle: nil)
            let vc = (itemStoryboard.instantiateViewController(identifier: "Item") as? ItemController)!
            vc.isEditMode = true
        if let validId = selectedCollection?.objectID{
                vc.selectedCollectionId = validId  
        }
            navigationController?.pushViewController(vc, animated: false)
    }
    
    private func setupAlgoliaSearch() {
        collectionIndex = keys.client.index(withName: "")
        query.hitsPerPage = 20
        
        // Limiting the attributes to be retrieved helps reduce response size and improve performance.
       // query.attributesToRetrieve = ["bookTitle", "bookSeries"]
        //query.attributesToHighlight = ["property1", "property2", "property3"]
    }
    
    private func itemSearchByCollection(forText searchString : String) {
        query.query = searchString
      query.filters = "collectionId: \(String(describing: (selectedCollection?.objectID)!))"
        collectionIndex.search(query: query) { result in
            if case .success(let response) = result {
                do {
                let j : [Item] = try response.extractHits()
                    self.collectionList = j
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print("ERROR")
                }
                
            }
        }
    }
}


extension ItemListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemStoryboard = UIStoryboard(name: "Item", bundle: nil)
        let vc = (itemStoryboard.instantiateViewController(identifier: "Item") as? ItemController)!
        if let validId = selectedCollection?.objectID{
                vc.selectedCollectionId = validId
        }
        vc.originalItem = collectionList[indexPath.row]
        searchBar.endEditing(true)
        navigationController?.pushViewController(vc, animated: false)
    }
}


extension ItemListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = collectionList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for : indexPath) as! DisplayCell
            cell.displayCellLabel.text = item.title
            cell.displayCellImage.image = UIImage(named : "placeHolder")
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

extension ItemListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            itemSearchByCollection(forText: "")
        }else {
            itemSearchByCollection(forText: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
