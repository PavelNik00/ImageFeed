//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 14.12.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let profileImage = UIImageView(image: UIImage(named: "avatar"))
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton(type: .custom)
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        setupProfileImage()
        setupNameLabel()
        setupLoginNameLabel()
        setupDescriptionLabel()
        setupLogoutButton()
        
        updateProfileDetails(profile: profileService.profile)
    }
    
    // MARK: - Private Func
    
    // отписываемся от наблюдений при выходе пользователя
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    private func setupProfileImage() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 35
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        view.addSubview(profileImage)
        
        profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func setupNameLabel() {
        configureLabel(nameLabel, text: "Екатерина Новикова", fontSize: 23)
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupLoginNameLabel() {
        configureLabel(loginNameLabel, text: "@ekaterina_nov", fontSize: 13)
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
    
    private func setupDescriptionLabel() {
        configureLabel(descriptionLabel, text: "Hello, world!", fontSize: 13)
        descriptionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupLogoutButton() {
        guard let image = UIImage(named: "logout_button", in: Bundle.main, compatibleWith: nil) else {
            return
        }
        
        logoutButton.setImage(image, for: .normal)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
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
    
    // MARK: - IB Action
    @IBAction private func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
    }
}

private extension ProfileViewController {
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarUrl,
            let url = URL(string: profileImageURL) else { return }
        
//        let cache = ImageCache.default
//        cache.clearMemoryCache()
//        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor)]
        ) {
            result in
            switch result {
            case .success(let value):
                print(value.image)
            case .failure(let error):
                print(error)
            }
        }
    }
}
