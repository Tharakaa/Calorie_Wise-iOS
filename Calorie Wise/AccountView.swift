//
//  AccountView.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-03.
//

import UIKit

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
        ApiCall.logout()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func goToBookmarks() {
        navigationController?.pushViewController(BookmarkListView(), animated: true)
    }
    
    func setupView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        
        let nameLabel = UILabel();
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Name"
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        nameLabel.adjustsFontForContentSizeCategory = true
        
        let nameValue = UILabel();
        nameValue.translatesAutoresizingMaskIntoConstraints = false
        nameValue.text = ApiCall.user?.name
        nameValue.numberOfLines = 0
        nameValue.font = UIFont.preferredFont(forTextStyle: .headline)
        nameValue.adjustsFontForContentSizeCategory = true
        
        let emailLabel = UILabel();
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email"
        emailLabel.numberOfLines = 0
        emailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        emailLabel.adjustsFontForContentSizeCategory = true
        
        let emailValue = UILabel();
        emailValue.translatesAutoresizingMaskIntoConstraints = false
        emailValue.text = ApiCall.user?.username
        emailValue.numberOfLines = 0
        emailValue.font = UIFont.preferredFont(forTextStyle: .headline)
        emailValue.adjustsFontForContentSizeCategory = true
        
        let bookmarkGesture: UITapGestureRecognizer!
        bookmarkGesture = UITapGestureRecognizer(target: self, action: #selector(goToBookmarks))
        
        let container = UIView();
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGray6
        container.addGestureRecognizer(bookmarkGesture)
        
        let bookmarksLabel = UILabel();
        bookmarksLabel.translatesAutoresizingMaskIntoConstraints = false
        bookmarksLabel.text = "Saved Recipes"
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
        
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameValue)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailValue)
        scrollView.addSubview(container)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -35),
            nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
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