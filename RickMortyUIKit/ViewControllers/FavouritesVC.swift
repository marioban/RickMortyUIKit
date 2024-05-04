//
//  FavouritesVC.swift
//  RickMortyUIKit
//
//  Created by Mario Ban on 31.01.2023..
//

import UIKit
import RealmSwift

class FavouritesVC: UIViewController {

    var realmDB: Realm!
    
    var savedCharacters : [SavedCharacter] = []
    var filteredCharacters: [SavedCharacter] = []
    
    let realmWrapper = RealmWrapper()
    var savedCharacter = SavedCharacter()
    
    var isSearching = false
    var isLoading = false
    
    var tableView = UITableView()
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTableView()
        
        configureNavBar()
        
        displayFavorites()
        
        // initializing refresh control
        tableView.refreshControl = UIRefreshControl()
        
        //add target to UIRefreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    @objc func callPullToRefresh(){
        savedCharacters = Array( realmWrapper.getObjects(objects: SavedCharacter.self)!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func displayFavorites() {
        savedCharacters = Array( realmWrapper.getObjects(objects: SavedCharacter.self)!)
        self.tableView.reloadData()
    }
    
    func configureNavBar() {
        searchBar.sizeToFit()
        
        searchBar.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Favorites"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    }
    
    @objc func showSearchBar(){
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Registracija
        self.tableView.register(FavouritesListTableViewCell.self, forCellReuseIdentifier: "FavouritesListTableViewCell")
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
}

// MARK: - UITableViewDelegate/DataSource  
extension FavouritesVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedCharacter: SavedCharacter
        
        if isSearching{
            savedCharacter = self.filteredCharacters[indexPath.row]
        } else{
            savedCharacter = self.savedCharacters[indexPath.row]
        }
        
        let savedCharactersDetails = SavedCharacterDetailsVC()
        
        savedCharactersDetails.savedCharacter = savedCharacter
        self.navigationController?.pushViewController(savedCharactersDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCharacters.count
        }
        
        return savedCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "FavouritesListTableViewCell")! as! FavouritesListTableViewCell
        
        let savedCharacter: SavedCharacter
        
        if isSearching {
            savedCharacter = self.filteredCharacters[indexPath.row]
        } else {
            savedCharacter = self.savedCharacters[indexPath.row]
        }
        
        let url = URL(string: savedCharacter.image)
        tableViewCell.image.kf.setImage(with: url)
         
        
        tableViewCell.nameTextLabel.text = savedCharacter.name
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        let savedCharacter: SavedCharacter
        if isSearching {
            savedCharacter = self.filteredCharacters[indexPath.row]
            filteredCharacters.remove(at: indexPath.row)
            let index = savedCharacters.firstIndex(of: savedCharacter)!
            savedCharacters.remove(at: index)
        } else {
            savedCharacter = self.savedCharacters[indexPath.row]
            savedCharacters.remove(at: indexPath.row)
        }
        
        realmWrapper.deleteChracter(withName: savedCharacter.name)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.displayFavorites()
    }
    
    
}


// MARK: - UITableViewCell
class FavouritesListTableViewCell: UITableViewCell {
    let nameTextLabel: UILabel = UILabel()
    let image: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        image.layer.cornerRadius = 50.0
        image.layer.masksToBounds = true
        
        self.addSubview(nameTextLabel)
        self.addSubview(image)
        
        nameTextLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        image.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.trailing.equalToSuperview().offset(-10.0)
            make.top.equalToSuperview().offset(10)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("Not defined")
    }
}


// MARK: - UISearchBarDelegate
extension FavouritesVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        filteredCharacters = savedCharacters.filter({$0.name.lowercased().contains(searchText.lowercased())})
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       search(shouldShow: false)
        isSearching = false
        tableView.reloadData()
    }
}
