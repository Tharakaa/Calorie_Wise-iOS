//
//  CategoryCell.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit

// protocol which can be implemented in table controller class to detect cell clicks
protocol CategoryDelegate {
    func didPressCell(sender: Category)
}
// Table cell class
class CategoryCell: UITableViewCell {
    
    var delegate:CategoryDelegate!
    let label = UILabel();
    let categoryButton = UIButton()
    var imageObj = UIImage();
    
    var category : Category? {
        didSet {
            // set details dynamically
            categoryButton.setTitle(category?.name, for: .normal)
            categoryButton.setBackgroundImage(category?.image, for: .normal)
            categoryButton.setTitleColor(category?.fontColor, for: .normal)
            categoryButton.imageView?.layer.cornerRadius = 6
            categoryButton.subviews.filter{$0 is UIImageView}.forEach {
                $0.contentMode = .scaleAspectFill
                $0.layer.cornerRadius = 6
            }
        }
    }
    
    // on click current category is sent through delegate
    @objc func cellClicked() {
        delegate.didPressCell(sender: category!)
    }
    
    // Setting UI item properties and alignments
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        categoryButton.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        categoryButton.layer.cornerRadius = 6
        categoryButton.layer.borderWidth = 1;
        categoryButton.layer.borderColor = UIColor.systemGray.cgColor
        categoryButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(self, action: #selector(cellClicked), for: .touchUpInside)
        
        categoryButton.titleLabel!.layer.shadowColor = UIColor.black.cgColor
        categoryButton.titleLabel!.layer.shadowRadius = 4.0
        categoryButton.titleLabel!.layer.shadowOpacity = 0.9
        categoryButton.titleLabel!.layer.shadowOffset = CGSize(width: 0, height: 0)
        categoryButton.titleLabel!.layer.masksToBounds = false
        
        categoryButton.backgroundColor = .systemGray6
        
        // setting properties of images
        categoryButton.subviews.filter{$0 is UIImageView}.forEach {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 6
        }
        
        contentView.addSubview(categoryButton)
        
        NSLayoutConstraint.activate([
            categoryButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -30),
            categoryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
