//
//  AccountView.swift
//  Calorie Wise
//
//  Created by Tharaka Gamachchi on 2023-01-03.
//

import UIKit

// Account details view. Visible after login in.
class AccountView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Account"
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutClicked))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc func logoutClicked() {
        // Confirm and Clear data when loggin out
        let logoutAlert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: .alert)
        logoutAlert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
            ApiCall.logout()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(logoutAlert, animated: true, completion: nil)
    }
    
    @objc func goToBookmarks() {
        navigationController?.pushViewController(BookmarkListView(), animated: true)
    }
    
    // setup UI elements and layout constraints.
    func setupView() {
        view.backgroundColor = .systemBackground
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        
        let personIcon = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        let personView = UIImageView(image: personIcon)
        personView.translatesAutoresizingMaskIntoConstraints = false
        personView.contentMode = .scaleAspectFit
        
        let nameLabel = UILabel();
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Name"
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        nameLabel.adjustsFontForContentSizeCategory = true
        
        let nameValue = UILabel();
        nameValue.translatesAutoresizingMaskIntoConstraints = false
        nameValue.text = ApiCall.user?.name
        nameValue.textAlignment = .center
        nameValue.numberOfLines = 0
        nameValue.font = UIFont.preferredFont(forTextStyle: .title2)
        nameValue.adjustsFontForContentSizeCategory = true
        
        let emailLabel = UILabel();
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email"
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
        emailLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        emailLabel.adjustsFontForContentSizeCategory = true
        
        let emailValue = UILabel();
        emailValue.translatesAutoresizingMaskIntoConstraints = false
        emailValue.text = ApiCall.user?.username
        emailValue.textAlignment = .center
        emailValue.numberOfLines = 0
        emailValue.font = UIFont.preferredFont(forTextStyle: .title2)
        emailValue.adjustsFontForContentSizeCategory = true
        
        let bookmarkGesture: UITapGestureRecognizer!
        // register tap gesture action to call methods.
        bookmarkGesture = UITapGestureRecognizer(target: self, action: #selector(goToBookmarks))
        
        let container = UIView();
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGray6
        container.addGestureRecognizer(bookmarkGesture)
        
        let bookmarksLabel = UILabel();
        bookmarksLabel.translatesAutoresizingMaskIntoConstraints = false
        bookmarksLabel.text = "Favourite Items"
        bookmarksLabel.numberOfLines = 0
        bookmarksLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        bookmarksLabel.adjustsFontForContentSizeCategory = true
        
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        container.addSubview(bookmarksLabel)
        container.addSubview(imageView)
        
        scrollView.addSubview(personView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameValue)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailValue)
        scrollView.addSubview(container)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeTopAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            personView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            personView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.2),
            personView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.12),
            personView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -35),
            nameLabel.topAnchor.constraint(equalTo: personView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameValue.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -35),
            nameValue.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameValue.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            emailLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -35),
            emailLabel.topAnchor.constraint(equalTo: nameValue.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            emailValue.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -35),
            emailValue.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailValue.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            container.topAnchor.constraint(equalTo: emailValue.bottomAnchor, constant: 30),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 5),
            container.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            bookmarksLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            bookmarksLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20),
            bookmarksLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -25),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
        ])
    }

}
