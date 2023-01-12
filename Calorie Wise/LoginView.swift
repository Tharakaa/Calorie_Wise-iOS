//
//  LoginView.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-01.
//

import UIKit
import Lottie

class LoginView: UIViewController {
    
    let usernameField = UITextField()
    let passwordField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    @objc func goToRegister() {
        navigationController?.pushViewController(RegisterView(), animated: true)
    }
    
    @objc func loginClicked() {
        var isValid = true;
        if (!checkAndShake(field: usernameField)) {isValid = false}
        if (!checkAndShake(field: passwordField)) {isValid = false}
        guard isValid else {
            return
        }
        
        let username = usernameField.text
        let password = passwordField.text
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard emailPred.evaluate(with: username) else {
            usernameField.layer.borderWidth = 2
            usernameField.layer.cornerRadius = 6
            usernameField.layer.borderColor = UIColor.systemRed.cgColor
            let alert = UIAlertController(title: "Alert", message: "Please enter a valid email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let parameters: [String: String?] = ["username": username, "password": password]
        
        let child = SpinnerViewController()
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        ApiCall.login(parameters: parameters){ (result) in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            if (result == 0) {
                var animationView = LottieAnimationView()
                animationView.translatesAutoresizingMaskIntoConstraints = false
                animationView = .init(name: "42135-done")
                animationView.frame = self.view.frame
                animationView.backgroundColor = .systemGray3
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .playOnce
                animationView.animationSpeed = 0.8
                
                self.view.addSubview(animationView)
                
                animationView.play(completion: {_ in
                    self.navigationController?.popToRootViewController(animated: true)
                })
            } else if (result == 1) {
                let alert = UIAlertController(title: "Alert", message: "Username or Password is incorrect. Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func checkAndShake(field: UITextField) -> Bool {
        let fieldText = field.text
        if (fieldText == nil || fieldText!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            CellAnimator().shakeView(viewToShake: field)
            field.layer.borderWidth = 2
            field.layer.cornerRadius = 6
            field.layer.borderColor = UIColor.systemRed.cgColor
            return false
        } else {
            return true
        }
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        let loginCard = UIView()
        loginCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginCard)
        
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.placeholder = "Email"
        usernameField.backgroundColor = .systemFill
        usernameField.borderStyle = .roundedRect
        usernameField.returnKeyType = UIReturnKeyType.next
        usernameField.autocapitalizationType = UITextAutocapitalizationType.none
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        usernameField.keyboardType = UIKeyboardType.emailAddress
        loginCard.addSubview(usernameField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true;
        passwordField.backgroundColor = .systemFill
        passwordField.borderStyle = .roundedRect
        passwordField.returnKeyType = UIReturnKeyType.done
        loginCard.addSubview(passwordField)
        
        let loginButton = UIButton()
//        loginButton.configuration = .filled()
//        loginButton.configuration?.baseBackgroundColor = .systemBlue
//        loginButton.configuration?.title = "Login"
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 6
        loginButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        
        loginCard.addSubview(loginButton)
        
        let registerButton = UIButton()
        registerButton.setTitle("create an account", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        //registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 6
        registerButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
//        registerButton.configuration = .borderless()
//        registerButton.configuration?.title = "create an account"
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        loginCard.addSubview(registerButton)
        
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.tag = 1
        passwordField.tag = 2
        
        NSLayoutConstraint.activate([
            loginCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginCard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginCard.heightAnchor.constraint(equalToConstant: 250),
            loginCard.widthAnchor.constraint(equalToConstant: 320),
            
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            usernameField.centerYAnchor.constraint(equalTo: loginCard.centerYAnchor, constant: -80),
            usernameField.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
            
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            passwordField.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
            
            loginButton.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.9),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
            
            registerButton.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.9),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            registerButton.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor)
        ])
    }
    
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 6
    }
}
