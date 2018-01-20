//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/12/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    let cellId: String = "cellId"

    var filteredUsers: [User] = []
    var users: [User] = []

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.grayBackfield
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        return searchBar
    }()

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }

        self.collectionView?.reloadData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()

        let user = filteredUsers[indexPath.item]
         print(user.username)

        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag

        navigationController?.navigationBar.addSubview(searchBar)

        let navBar = navigationController?.navigationBar

        searchBar.anchor(topAnchor: navBar?.topAnchor, leftAnchor: navBar?.leftAnchor, bottomAnchor: navBar?.bottomAnchor, rightAnchor: navBar?.rightAnchor, paddingLeft: 8, paddingRight: 8)

        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)

        fetchUsers()
    }

    func fetchUsers() {
        Service.shared.fetchUsers { (dictionaries) in
            dictionaries.forEach({ (key, value) in
                guard let uid = Service.getCurrentUid(), key != uid else { return }
                guard let dictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: dictionary)
                self.users.append(user)
            })
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserSearchCell else { return UICollectionViewCell() }

        cell.user = filteredUsers[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width
        return CGSize(width: width, height: 66)
    }
}
