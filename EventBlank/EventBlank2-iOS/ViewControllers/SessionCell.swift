//
//  SessionCell.swift
//  EventBlank2-iOS
//
//  Created by Marin Todorov on 4/9/16.
//  Copyright © 2016 Underplot ltd. All rights reserved.
//

import UIKit
import RealmSwift

import RxSwift
import RxCocoa

import Then

class SessionCell: UITableViewCell, ClassIdentifier {
    
    private let bag = DisposeBag()

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var speakerImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var btnToggleIsFavorite: UIButton!
    @IBOutlet weak var btnSpeakerIsFavorite: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnToggleIsFavorite.setImage(UIImage(named: "like-full")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Selected)
        
        btnSpeakerIsFavorite.setImage(UIImage(named: "like-full")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Selected)
        btnSpeakerIsFavorite.setImage(nil, forState: .Normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        speakerImageView.image = nil
    }

    static func cellOfTable(tv: UITableView, session: Session) -> SessionCell {
        return tv.dequeueReusableCell(SessionCell).then {cell in
            cell.populateFromSession(session)
        }
    }
    
    func populateFromSession(session: Session) {
        
        titleLabel.text = session.title
        speakerLabel.text = session.speakers.first!.name
        trackLabel.text = session.track?.track ?? ""
        
        timeLabel.text = shortStyleDateFormatter.stringFromDate(session.beginTime!)
        
        let userImage = session.speakers.first!.photo ?? UIImage(named: "empty")!
        userImage.asyncToSize(.FillSize(speakerImageView.bounds.size), cornerRadius: speakerImageView.bounds.size.width/2, completion: {result in
            self.speakerImageView.image = result
        })
        
        locationLabel.text = session.location?.location
        
        //btnToggleIsFavorite.selected = isFavoriteSession
        //btnSpeakerIsFavorite.selected = isFavoriteSpeaker
        
        //theme
        let realm = try! Realm()
        let event = realm.objects(EventData).first!
        
        titleLabel.textColor = event.mainColor
        trackLabel.textColor = event.mainColor.lightenColor(0.1).desaturatedColor()
        speakerLabel.textColor = UIColor.blackColor()
        locationLabel.textColor = UIColor.blackColor()
        
        //check if in the past
        if let beginTime = session.beginTime where NSDate().isLaterThanDate(beginTime) {
            titleLabel.textColor = titleLabel.textColor.desaturateColor(0.5).lighterColor()
            trackLabel.textColor = titleLabel.textColor
            speakerLabel.textColor = UIColor.grayColor()
            locationLabel.textColor = UIColor.grayColor()
        }
    }

}