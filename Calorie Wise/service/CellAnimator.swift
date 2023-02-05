//
//  CellAnimator.swift
//  Calorie Wise
//
//  Created by Tharaka Gamachchi on 2023-01-05.
//

import UIKit

// Responsible for all animations within the application.
typealias TableCellAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

final class TableViewAnimator {
    private let animation: TableCellAnimation
    
    init(animation: @escaping TableCellAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        animation(cell, indexPath, tableView)
    }
}

class CellAnimator {
    //https://medium.com/@shubham_iosdev/animate-the-boring-tableviews-in-your-ios-app-a98bc6dee3e9
    func getAnimator(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> TableViewAnimator {
        let animation = makeMoveUpBounceAnimation(rowHeight: rowHeight, duration: duration, delayFactor: delayFactor)
        return TableViewAnimator(animation: animation)
    }

    // Make the table cells bounce upon loading.
    func makeMoveUpBounceAnimation(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> TableCellAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
        }
    }
    
    //https://stackoverflow.com/a/27988876
    // make input fields shake. Used to denote invalid fields.
    func shakeView(viewToShake: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        viewToShake.layer.add(animation, forKey: "position")
    }
}

// Add a progress spinner to screen.
class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension UIViewController {
    // show a android like toast when certain API actions are finished.
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false;
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        toastLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -10).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        UIView.animate(withDuration: 1.5, delay: 1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

