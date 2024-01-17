//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 14.12.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileImage = UIImageView(image: UIImage(named: "avatar"))
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton.systemButton(
        with: UIImage(named: "logout_button", in: Bundle.main, compatibleWith: nil)!,
        target: ProfileViewController.self,
        action: #selector(Self.didTapLogoutButton)
    )

    @IBAction private func didTapLogoutButton() {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImage()
        setupNameLabel()
        setupLoginNameLabel()
        setupDescriptionLabel()
        setupLogoutButton()
    }

    private func setupProfileImage() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        view.addSubview(profileImage)
        
        profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }

    private func setupNameLabel() {
        configureLabel(nameLabel, text: "Екатерина Новикова", fontSize: 23)
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
    }

    private func setupLoginNameLabel() {
        configureLabel(loginNameLabel, text: "@ekaterina_nov", fontSize: 13)
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
    }

    private func setupDescriptionLabel() {
        configureLabel(descriptionLabel, text: "Hello, world!", fontSize: 13)
        descriptionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
    }

    private func setupLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)

        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
    }

    private func configureLabel(_ label: UILabel, text: String, fontSize: CGFloat) {
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }
}
