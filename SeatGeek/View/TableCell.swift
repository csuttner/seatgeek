//
//  TableCell.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/28/21.
//

// Custom TableCell class to obtain desired styling

import UIKit

class TableCell: UITableViewCell {
    
    // Get access to repository for getting event-related data (liked / unliked, image from cache)
    let repository = Repository.instance
    
    // Use init to add and layout views so we only have to do this once
    // The properties of these views can then be modified in configurefor(event:) on each dequeueing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Customize properties of cell views based on specified event
    func configureFor(event: Event) {
        let location = event.venue.city + ", " + event.venue.state
        let date = Date.fromIso(event.datetime_utc)
        
        locationLabel.text = location
        dateTimeLabel.text = date.dateString() + "\n" + date.timeString()
        titleLabel.text = event.title
        
        // Get image of event from cache
        cellImageView.image = repository.getImage(event: event)
        
        // Add and layout like heart to cell if this event is liked
        if repository.isLiked(event: event) {
            addLikeView()
        } else {
            heartFillView.removeFromSuperview()
        }
    }
    
    // MARK:- UI Views
    
    // Located UI elements here to place core logic first in your review
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .cornerRadius
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let heartFillView = UIImageView(image: UIImage(named: "heart-fill"))
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .mainTextSize, weight: .heavy)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .subTextSize)
        label.textColor = .darkGray
        return label
    }()
        
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .subTextSize)
        label.textColor = .darkGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    // MARK:- UI Setup
    
    // Only called if event is liked
    func addLikeView() {
        contentView.addSubview(heartFillView)
        heartFillView.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            paddingTop: .betweenPadding,
            paddingLeft: .horizPadding,
            width: .iconSize / 1.25,
            height: .iconSize / 1.25
        )
    }
    
    // Separate adding and layout of views
    func addViews() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateTimeLabel)
    }
    
    // Utilizing UIView anchor extension for more elegant layout syntax
    func layoutViews() {
        cellImageView.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            paddingTop: .horizPadding,
            paddingLeft: .vertPadding,
            width: .cellImageSize,
            height: .cellImageSize
        )
        
        titleLabel.anchor(
            top: contentView.topAnchor,
            left: cellImageView.rightAnchor,
            right: contentView.rightAnchor,
            paddingTop: .horizPadding,
            paddingLeft: .vertPadding,
            paddingRight: .vertPadding
        )
        
        locationLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: cellImageView.rightAnchor,
            right: contentView.rightAnchor,
            paddingTop: .betweenPadding,
            paddingLeft: .vertPadding
        )
        
        dateTimeLabel.anchor(
            top: locationLabel.bottomAnchor,
            left: cellImageView.rightAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            paddingTop: .betweenPadding,
            paddingLeft: .vertPadding,
            paddingBottom: .horizPadding,
            paddingRight: .vertPadding
        )
    }

}
