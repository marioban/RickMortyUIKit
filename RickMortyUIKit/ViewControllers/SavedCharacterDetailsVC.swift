//
//  SavedCharacterDetailsVC.swift
//  RickMortyUIKit
//
//  Created by Mario Ban on 31.01.2023..
//

import UIKit
import Kingfisher
import SnapKit
import RealmSwift

class SavedCharacterDetailsVC: UIViewController {
    
    var savedCharacter: SavedCharacter?
    let isFavourite = false
    let isClicked = false
    var realmDB = try! Realm()
    
    override func loadView() {
        let viewVC = SavedCharacterDetailsView(savedCharacter: savedCharacter)
        self.view = viewVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    

}
// MARK: - SavedCharacterDetailsView
final class SavedCharacterDetailsView: UIView{
    var savedCharacter: SavedCharacter?
    var charactersDetails = CharacterDetailsVC()
    var realmWrapper = RealmWrapper()
    var newCharacter = SavedCharacter()

    private lazy var favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
        favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.selected)
        favouriteButton.addTarget(self, action: #selector(button), for: .touchUpInside)
        addSubview(favouriteButton)
        return favouriteButton
    }()
    

    @objc private func button() {
        if (favouriteButton.isSelected) {
            realmWrapper.saveObjects(objects: newCharacter)
            favouriteButton.isSelected = true
        } else {
            realmWrapper.deleteChracter(withName: savedCharacter!.name)
            favouriteButton.isSelected = false
        }
    }
    
    private lazy var characterName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KohinoorBangla-Regular", size: 34)
        label.textAlignment = .center
        label.text = savedCharacter?.name
        addSubview(label)
        return label
    }()
    
    private lazy var characterImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 100
        let url = URL(string: savedCharacter!.image)
        image.kf.setImage(with: url)
        
        image.layer.masksToBounds = true
        
        addSubview(image)
        return image
    }()
    
    private lazy var characterStatus: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KohinoorBangla-Regular", size: 22)
        label.textAlignment = .center
        label.text = savedCharacter?.status
        addSubview(label)
        return label
    }()
    
    private lazy var characterSpecies: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KohinoorBangla-Regular", size: 22)
        label.textAlignment = .center
        label.text = savedCharacter?.species
        addSubview(label)
        return label
    }()
    
    private lazy var stackViewFavorites: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favouriteButton])
        stackView.axis = .vertical
        addSubview(stackView)
        return stackView
    }()

    private lazy var stackViewImage: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [characterImage])
        stackView.axis = .vertical
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var stackViewCharacterName: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [characterName])
        stackView.axis = .vertical
        addSubview(stackView)
        return stackView
    }()

    
    private lazy var stackViewStatus: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [characterStatus])
        stackView.axis = .vertical
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var stackViewSpecies: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [characterSpecies])
        stackView.axis = .vertical
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var stackViewDetils: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewCharacterName,stackViewStatus,stackViewSpecies])
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        addSubview(stackView)
        return stackView
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(savedCharacter: SavedCharacter?) {
        super.init(frame: .zero)
        
        self.savedCharacter = savedCharacter
        
        self.newCharacter = SavedCharacter(savedCharacter: savedCharacter!)
        
        self.setupView()
        
        favouriteButton.isSelected = realmWrapper.doesExist(name: savedCharacter!.name)
    }
    
    private func setupView(){
        stackViewFavorites.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(-85)
            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
        }

        stackViewImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        
        stackViewDetils.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(150)
        }
        
    }
    

}
