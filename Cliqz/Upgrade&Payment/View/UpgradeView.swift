//
//  UpgradeView.swift
//  Client
//
//  Created by Mahmoud Adam on 1/29/19.
//  Copyright © 2019 Cliqz. All rights reserved.
//

import UIKit
import QuartzCore


protocol UpgradeLumenDelegate: class {
    func showUpgradeViewController()
}

struct UpgradeViewUX {
    static let height: CGFloat = 50.0
}

class UpgradeView: UIView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel1 = UILabel()
    private let subtitleLabel2 = UILabel()
    private let upgradeButton = UIButton()
    
    weak var delegate: UpgradeLumenDelegate?
    private let view: String
    
    init(view: String) {
        self.view = view
        super.init(frame: CGRect.zero)
        self.setupComponents()
        self.setStyles()
        self.setConstraints()
        LegacyTelemetryHelper.logMessage(action: "show", topic: "upgrade", style: "notification", view: view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	func updateViewState(isEnabled: Bool) {
		#if PAID
		if isEnabled {
			titleLabel.textColor = UIColor.theme.lumenSubscription.upgradeLabel
			subtitleLabel1.textColor = UIColor.theme.lumenSubscription.upgradeLabel
			subtitleLabel2.textColor = UIColor.theme.lumenSubscription.upgradeLabel
			upgradeButton.setTitleColor(UIColor.white, for: .normal)
			upgradeButton.isEnabled = true
		} else {
			titleLabel.textColor = UIColor.lumenDisabled
			subtitleLabel1.textColor = UIColor.lumenDisabled
			subtitleLabel2.textColor = UIColor.lumenDisabled
			upgradeButton.setTitleColor(UIColor.lumenDisabled, for: .normal)
			upgradeButton.isEnabled = false
		}
		#endif
	}

    fileprivate func setupComponents() {
        if let trialRemainingDays = SubscriptionController.shared.getCurrentSubscription().trialRemainingDays() {
            titleLabel.text = NSLocalizedString("Stay with us", tableName: "Lumen", comment: "Upgrade lumen view title")
            subtitleLabel1.text = String(format: NSLocalizedString("Only %d days left in trial.", tableName: "Lumen", comment: "Upgrade lumen view subtitle1"), trialRemainingDays)
            subtitleLabel2.text = NSLocalizedString("Keep ultimate protection and VPN.", tableName: "Lumen", comment: "Upgrade lumen view subtitle2")
            upgradeButton.setTitle(NSLocalizedString("UPGRADE", tableName: "Lumen", comment: "Upgrade lumen view button text"), for: .normal)
        } else {
            titleLabel.text = NSLocalizedString("Ultimate Protection: OFF", tableName: "Lumen", comment: "Upgrade lumen view title")
            subtitleLabel1.text = NSLocalizedString("You are browsing without ultimate protection and ad blocker.", tableName: "Lumen", comment: "Upgrade lumen view subtitle")
            subtitleLabel1.numberOfLines = 2
            upgradeButton.setTitle(NSLocalizedString("Turn On", tableName: "Lumen", comment: "Turn on CTA"), for: .normal)
        }
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        subtitleLabel1.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel2.font = UIFont.systemFont(ofSize: 12)
        upgradeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        upgradeButton.addTarget(self, action: #selector(upgradeToPremium), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(subtitleLabel1)
        addSubview(subtitleLabel2)
        addSubview(upgradeButton)
    }
    
    fileprivate func setStyles() {
        #if PAID
        titleLabel.textColor = UIColor.theme.lumenSubscription.upgradeLabel
        subtitleLabel1.textColor = UIColor.theme.lumenSubscription.upgradeLabel
        subtitleLabel2.textColor = UIColor.theme.lumenSubscription.upgradeLabel
        upgradeButton.setTitleColor(UIColor.white, for: .normal)
        upgradeButton.backgroundColor = UIColor.lumenBrightBlue
        upgradeButton.layer.cornerRadius = 15
        #endif
    }
    
    fileprivate func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        subtitleLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalTo(upgradeButton.snp.leading).offset(-25)
        }
        
        subtitleLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(subtitleLabel1.snp.bottom)
            make.leading.equalToSuperview()
        }
        
        upgradeButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(110.0)
            make.height.equalTo(30.0)
        }
    }
    
    @objc func upgradeToPremium() {
        delegate?.showUpgradeViewController()
        LegacyTelemetryHelper.logMessage(action: "click", topic: "upgrade", style: "notification", view: view, target: "upgrade")
    }
}


extension UpgradeView : Themeable {
    func applyTheme() {
        self.setStyles()
    }
}
