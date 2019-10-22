//
//  DetailViewController.swift
//  NYTimesGroupProj
//
//  Created by Anthony Gonzalez on 10/18/19.
//  Copyright © 2019 Kimball Yang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy var bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.red
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        return imageView
    }()
    
    lazy var bookTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = . white
        textView.font = UIFont.systemFont(ofSize: 21)
        textView.isEditable = false
        textView.textAlignment = .center
        view.addSubview(textView)
        
        return textView
    }()
    
    lazy var amazonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "amazon-icon"), for: .normal)
        button.addTarget(self, action: #selector(amazonButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(favoritesButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        view.addSubview(button)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        view.addSubview(button)
        return button
    }()
    
    var currentBook: NYTimeBook!
    
    @objc private func favoritesButtonPressed(){
        let favoritedBook = currentBook
        
        do {
            try? FavoriteBookPersistenceHelper.manager.save(newBook: favoritedBook!)
        }
        presentAlert()
    }
    
    @objc private func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func amazonButtonPressed() {
        if let url = URL(string: currentBook.amazon_product_url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func presentAlert(){
        let alertVC = UIAlertController(title: nil, message: "Added \(currentBook.title) to favorites!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setButtonConstraints() {
        NSLayoutConstraint.activate([
            amazonButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150),
            amazonButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            amazonButton.heightAnchor.constraint(equalToConstant: 60),
            amazonButton.widthAnchor.constraint(equalToConstant: 60),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150),
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -150),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    private func setTextViewConstraints() {
        NSLayoutConstraint.activate([
            bookTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 340),
            bookTextView.heightAnchor.constraint(equalToConstant: 130),
            bookTextView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    
    private func setBookImageConstraints() {
        NSLayoutConstraint.activate([
            bookImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            bookImage.heightAnchor.constraint(equalToConstant: 450),
            bookImage.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.2914385796, green: 0.1974040866, blue: 0.4500601888, alpha: 1)
        bookTextView.text = currentBook.description
        
        ImageHelper.shared.getImage(urlStr: currentBook.book_image) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let imageFromOnline):
                UIView.transition(with: self.bookImage, duration: 1.1, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    DispatchQueue.main.async {
                        self.bookImage.image = imageFromOnline
                    }
                    
                }, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBookImageConstraints()
        setTextViewConstraints()
        setButtonConstraints()
        configureUI()
        
    }
}
