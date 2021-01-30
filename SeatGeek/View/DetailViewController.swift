//
//  DetailViewController.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/28/21.
//

// Controls detail view for events

import UIKit

class DetailViewController: UIViewController {
    
    // Get access to repository for getting event-related data (liked / unliked, image from cache)
    let repository = Repository.instance
    
    // Set event as class property so we can reference it to toggle liked / unliked
    var event: Event
    
    // Configure view for event on initialization for elegance upstream, as we aren't reusing this view
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
        
        // Set background color to custom asset, otherwise return from this view shows ui elements over table (bad)
        view.backgroundColor = UIColor(named: "background")
        configureForEvent()
        addViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForEvent() {
        let date = Date.fromIso(event.datetime_utc)
        let location = event.venue.city + ", " + event.venue.state

        dateTimeLabel.text = date.dateString() + " " + date.timeString()
        locationLabel.text = location
        titleLabel.text = event.title
        
        // Access repository for image from cache
        imageView.image = repository.getImage(event: event)
        
        setLikeButton()
    }
    
    // Action for likebutton
    @objc func toggleLike() {
        repository.toggleLike(event: event)
        setLikeButton()
    }
    
    // Set appropriate liked / unliked image
    func setLikeButton() {
        if repository.isLiked(event: event) {
            likeButton.setImage(heartFill, for: .normal)
        } else {
            likeButton.setImage(heartEmpty, for: .normal)
        }
    }
    
    // MARK: - UI Views
    
    // Located UI elements here to place core logic first in your review
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .titleTextSize, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let heartEmpty = UIImage(named: "heart-empty")
    
    let heartFill = UIImage(named: "heart-fill")
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        return button
    }()
    
    // Empty view to properly constrain views beneath title / heart for single and multiline cases
    let containerView = UIView()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .cornerRadius
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: .mainTextSize)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .subTextSize)
        label.textColor = .systemGray
        return label
    }()
    
    //MARK:- UI Setup
    
    // Separate adding and layout of views
    func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(likeButton)
        view.addSubview(separatorView)
        view.addSubview(imageView)
        view.addSubview(dateTimeLabel)
        view.addSubview(locationLabel)
    }
    
    func layoutViews() {
        containerView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: .horizPadding,
            paddingLeft: .vertPadding,
            paddingRight: .vertPadding
        )
        
        titleLabel.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor
        )
        
        likeButton.anchor(
            top: containerView.topAnchor,
            left: titleLabel.rightAnchor,
            right: containerView.rightAnchor,
            paddingLeft: .vertPadding,
            width: .iconSize,
            height: .iconSize
        )
        
        separatorView.anchor(
            top: containerView.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: .horizPadding,
            height: 2
        )
        
        imageView.anchor(
            top: separatorView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: .horizPadding,
            paddingLeft: .vertPadding,
            paddingBottom: .horizPadding,
            paddingRight: .vertPadding,
            height: view.frame.height / 3
        )
        
        dateTimeLabel.anchor(
            top: imageView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: .horizPadding,
            paddingLeft: .vertPadding,
            paddingRight: .vertPadding
        )
        
        locationLabel.anchor(
            top: dateTimeLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: .betweenPadding,
            paddingLeft: .vertPadding,
            paddingRight: .vertPadding
        )
    }
    
}
