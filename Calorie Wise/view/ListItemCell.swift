//
//  ListItemCell.swift
//  Calorie Wise
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit
import Lottie

// protocol which can be implemented in table controller class to detect cell clicks
protocol ListItemDelegate {
    func didPressCell(sender: Item)
    func goToLoginPress()
    func showToast(message: String)
}
class ListItemCell: UITableViewCell {
    
    var delegate:ListItemDelegate!
    let label = UILabel()
    let descriptionLabel = UILabel()
    let mainScore = UILabel();
    let badgeContainer = UIView()
    var animationView = LottieAnimationView()
    var imageContainer = UIImageView()
    let container = UIView()
    var isBookMarked = false
    
    var item : Item? {
        didSet {
            // set items and details dynamically
            let imageObj = item!.image
            imageContainer.image = imageObj
            descriptionLabel.text = "\(item?.calorie ?? 0) calories"
            mainScore.text = "\(item?.score ?? 0)"
            if (item != nil && item!.score < 6) {
                badgeContainer.backgroundColor = .systemOrange
            } else if (item != nil && item!.score < 8) {
                badgeContainer.backgroundColor = .systemYellow
            } else {
                badgeContainer.backgroundColor = .systemGreen
            }
            label.text = item?.name
            // set animation state of bookmark animation depending on bookmarked state of the user.
            isBookMarked = ((item?.isBookMarked) == true)
            if (isBookMarked) {
                self.animationView.currentProgress = 1
            } else {
                self.animationView.currentProgress = 0
            }
        }
    }
    
    // send clicked function to controller class through delegate
    @objc func cellClicked() {
        delegate.didPressCell(sender: item!)
    }
    
    // Called when bookmark icon is clicked.
    @objc func bookmarkItem() {
        // if not logged in. An alert is given saying to login
        if (ApiCall.isLoggedIn()) {
            if (isBookMarked) {
                animationView.play(fromProgress: 1, toProgress: 0, completion: {_ in
                    self.isBookMarked = false
                    self.item?.isBookMarked = false
                    self.animationView.currentProgress = 0
                    ApiCall.removeBookmark(item: self.item!._id!){ () in
                        self.delegate.showToast(message: "Removed from Favourites")
                    }
                })
            } else {
                animationView.play(fromProgress: 0, toProgress: 1, completion: {_ in
                    self.isBookMarked = true
                    self.item?.isBookMarked = true
                    self.animationView.currentProgress = 1
                    ApiCall.addBookmark(item: self.item!._id!){ () in
                        self.delegate.showToast(message: "Added to Favourites")
                    }
                })
            }
        } else {
            delegate.goToLoginPress()
        }
    }
    
    // set disaply item properties and layout constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var tapGesture: UITapGestureRecognizer!
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellClicked))
        
        container.layer.cornerRadius = 6
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addGestureRecognizer(tapGesture)
        
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.contentMode = .scaleAspectFill
        imageContainer.clipsToBounds = true
        imageContainer.layer.cornerRadius = 6
        imageContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Swiss Sandwitches Swiss Sandwitches"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontForContentSizeCategory = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        
        let fireIcon = UIImage(systemName: "flame")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let fireView = UIImageView(image: fireIcon)
        fireView.translatesAutoresizingMaskIntoConstraints = false
        fireView.contentMode = .scaleAspectFill
        fireView.clipsToBounds = true
        
        mainScore.translatesAutoresizingMaskIntoConstraints = false
        mainScore.numberOfLines = 0
        mainScore.font = label.font.withSize(22)
        mainScore.adjustsFontForContentSizeCategory = true
        
        let scoreOutOf = UILabel();
        scoreOutOf.translatesAutoresizingMaskIntoConstraints = false
        scoreOutOf.text = "/10"
        scoreOutOf.numberOfLines = 0
        scoreOutOf.font = label.font.withSize(10)
        scoreOutOf.adjustsFontForContentSizeCategory = true
        
        var bookmarkGesture: UITapGestureRecognizer!
        bookmarkGesture = UITapGestureRecognizer(target: self, action: #selector(bookmarkItem))
        
        // Add lottie animation as the bookmark button
        animationView = .init(name: "97064-bookmark-icon")
        animationView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.25
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.addGestureRecognizer(bookmarkGesture)
        
        container.addSubview(imageContainer)
        container.addSubview(label)
        container.addSubview(animationView)
        
        let calorieContainer = UIView()
        calorieContainer.translatesAutoresizingMaskIntoConstraints = false
        calorieContainer.backgroundColor = .systemGray5
        calorieContainer.layer.cornerRadius = 14
        calorieContainer.addSubview(fireView)
        calorieContainer.addSubview(descriptionLabel)
        container.addSubview(calorieContainer)
        
        badgeContainer.translatesAutoresizingMaskIntoConstraints = false
        badgeContainer.layer.cornerRadius = 10
        badgeContainer.addSubview(mainScore)
        badgeContainer.addSubview(scoreOutOf)
        container.addSubview(badgeContainer)
        
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -20),
            container.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: 20),
            
            imageContainer.heightAnchor.constraint(equalTo: container.heightAnchor),
            imageContainer.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.38),
            imageContainer.leftAnchor.constraint(equalTo: container.leftAnchor),
            imageContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            label.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.6, constant: -10),
            label.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            
            calorieContainer.topAnchor.constraint(equalTo: fireView.topAnchor, constant: -4),
            calorieContainer.leftAnchor.constraint(equalTo: fireView.leftAnchor, constant: -5),
            calorieContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2),
            calorieContainer.rightAnchor.constraint(equalTo: badgeContainer.leftAnchor, constant: -5),
            fireView.rightAnchor.constraint(equalTo: descriptionLabel.leftAnchor, constant: -3),
            fireView.bottomAnchor.constraint(equalTo: calorieContainer.bottomAnchor, constant: -3),
            descriptionLabel.rightAnchor.constraint(equalTo: calorieContainer.rightAnchor, constant: -7),
            descriptionLabel.centerYAnchor.constraint(equalTo: calorieContainer.centerYAnchor),
            
            badgeContainer.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
            badgeContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1),
            badgeContainer.leftAnchor.constraint(equalTo: mainScore.leftAnchor, constant: -3),
            badgeContainer.topAnchor.constraint(equalTo: mainScore.topAnchor, constant: 0),
            scoreOutOf.rightAnchor.constraint(equalTo: badgeContainer.rightAnchor, constant: -3),
            scoreOutOf.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor, constant: -3),
            mainScore.rightAnchor.constraint(equalTo: badgeContainer.rightAnchor, constant: -18),
            mainScore.bottomAnchor.constraint(equalTo: scoreOutOf.topAnchor, constant: 13),
            
            animationView.topAnchor.constraint(equalTo: container.topAnchor, constant: -11),
            animationView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: -15),
            animationView.heightAnchor.constraint(equalToConstant: 50),
            animationView.widthAnchor.constraint(equalToConstant: 50),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
