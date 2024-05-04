//
//  CharacterListVC.swift
//  RickMortyUIKit
//
//  Created by Mario Ban on 30.01.2023..
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - Spinner cell
class ActivityTableViewCell: UITableViewCell {
    let activitiyIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(activitiyIndicatorView)
        
        activitiyIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not defined")
    }
}

// MARK: - UITableViewCell
class CharacterListTableViewCell: UITableViewCell {
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

// MARK: - ViewController
class CharacterListVC: UIViewController {
    var currentPage = 1
    
    var characters: [Character] = []
    var filteredCharacters: [Character] = []
    var newCharacter = SavedCharacter()
    var isSearching = false
    var isLoading = false
    
    var rickMortyApi = RickMortyApi()
    
    var tableView = UITableView()
    let searchBar = UISearchBar()
    let realmWrapper = RealmWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTableView()

        loadApi()
        
        configureNavBar()
    }
    
    func configureNavBar() {
        searchBar.sizeToFit()
        
        searchBar.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Characters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    }
    
    @objc func showSearchBar(){
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    func loadApi() {
        self.isLoading = true
        self.rickMortyApi.getData(page: currentPage, completion: { result in
            self.characters.append(contentsOf: result.results)
            self.tableView.reloadData()
            self.isLoading = false
        })
        self.currentPage += 1
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
        self.tableView.register(CharacterListTableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        self.tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "Activity")
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

// MARK: - UITableViewDataSource/UITableViewDelegate
extension CharacterListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Dohvaćaš charactera
        let character: Character
        
        if isSearching {
            character = self.filteredCharacters[indexPath.row]
        } else {
            character  = self.characters[indexPath.row]
        }
        
        // 2. Inicijalizacija detail VC
        let characterVC = CharacterDetailsVC()
        
        // 3. Prenosiš podatke
        characterVC.character = character
        
        // 4. Push u navigation controller
        self.navigationController?.pushViewController(characterVC, animated: true)
        
        // 5. Deselect
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCharacters.count
        }
        
        return characters.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == characters.count) { // Da li je zadnji loading indikator
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Activity")! as! ActivityTableViewCell
            tableViewCell.activitiyIndicatorView.startAnimating()
            return tableViewCell
        }
        
        // Set-up za ostale čelije koje nisu loading
        
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CharacterCell")! as! CharacterListTableViewCell
        
        let character: Character
        
        if isSearching {
            character = self.filteredCharacters[indexPath.row]
        } else {
            character = self.characters[indexPath.row]
        }
        
        let url = URL(string: character.image)
        tableViewCell.image.kf.setImage(with: url)
        
        
        // Neki setup čelije ovdje
        // postaviš naslov itd.
        tableViewCell.nameTextLabel.text = character.name
        
        
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isSearching {
            return
        }
        
        //let spinner = ActivityTableViewCell()
        
        
        if (indexPath.row == characters.count) {
            
            if !isLoading{
                self.loadApi()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let character: Character
        
        if isSearching {
            character = self.filteredCharacters[indexPath.row]
        } else {
            character = self.characters[indexPath.row]
        }
        
        let title: String?
        let doesExist = realmWrapper.doesExist(name: character.name)
        if doesExist {
            title = "Unfavorite"
        } else {
            title = "Favorite"
        }
        
        let action = UIContextualAction(style: .normal, title: title){[weak self] (action,view,completionHandler) in
            if doesExist {
                self?.realmWrapper.deleteChracter(withName: character.name)
            } else {
                self?.newCharacter = SavedCharacter(character: character)
                self?.realmWrapper.saveObjects(objects: self!.newCharacter)
            }
            
            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    
}

// MARK: - UISearchBarDelegate
extension CharacterListVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        filteredCharacters = characters.filter({$0.name.lowercased().contains(searchText.lowercased())})
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       search(shouldShow: false)
        isSearching = false
        tableView.reloadData()
    }
}
