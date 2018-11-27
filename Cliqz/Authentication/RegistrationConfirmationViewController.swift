//
//  RegistrationConfirmationViewController.swift
//  Client
//
//  Created by Sahakyan on 11/15/18.
//  Copyright © 2018 Cliqz. All rights reserved.
//

import Foundation

class RegistrationConfirmationViewController: UIViewController {
	
	private let backgroundView = GradientBackgroundView()

	private let image = UIImageView()
	private let titleLabel = UILabel()
	private let descriptionLabel = UILabel()
	private let startButton = UIButton(type: .custom)

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.isNavigationBarHidden = true
		self.setupViews()
	}

	override func viewWillAppear(_ animated: Bool) {
		super .viewWillAppear(animated)
	}

	override open var shouldAutorotate: Bool {
		return false
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.backgroundView.snp.remakeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		self.backgroundView.gradient.frame = self.backgroundView.bounds

		self.startButton.snp.remakeConstraints { (make) in
			make.left.equalToSuperview().offset(29)
			make.right.equalToSuperview().offset(-29)
			make.bottom.equalToSuperview().offset(-63)
			make.height.equalTo(33)
		}
		self.descriptionLabel.snp.remakeConstraints { (make) in
			make.left.equalToSuperview().offset(29)
			make.right.equalToSuperview().offset(-29)
			make.bottom.equalTo(self.startButton.snp.top).offset(-40)
			make.height.equalTo(45)
		}
		self.titleLabel.snp.remakeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(self.descriptionLabel.snp.top).offset(-11)
			make.height.equalTo(24)
		}
		self.image.snp.remakeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(self.titleLabel.snp.top).offset(-104)
		}
	}
	
	private func setupViews() {
		self.view.addSubview(self.backgroundView)
		self.view.addSubview(self.image)
		self.view.addSubview(self.titleLabel)
		self.view.addSubview(self.descriptionLabel)
		self.view.addSubview(self.startButton)

		self.image.image = UIImage(named: "checkmarkAuthentication")

		self.titleLabel.text = NSLocalizedString("Welcome to Lumen!", tableName: "Cliqz", comment: "")
		self.titleLabel.textAlignment = .center
		self.titleLabel.textColor = AuthenticationUX.textColor
		self.titleLabel.font = AuthenticationUX.titleFont

		self.descriptionLabel.text = NSLocalizedString("Have fun with your free two-week trial and take your time to explore all Lumen features!", tableName: "Cliqz", comment: "")
		self.descriptionLabel.textAlignment = .center
		self.descriptionLabel.textColor = AuthenticationUX.textColor
		self.descriptionLabel.font = AuthenticationUX.subtitleFont
		self.descriptionLabel.numberOfLines = 2
		self.descriptionLabel.lineBreakMode = .byWordWrapping

		self.startButton.setTitle(NSLocalizedString("Start", tableName: "Cliqz", comment: ""), for: .normal)
		self.startButton.backgroundColor = UIColor(rgb: 0x2B66C2)
		self.startButton.layer.cornerRadius = 16
		self.startButton.layer.borderWidth = 0
		self.startButton.layer.masksToBounds = true
		self.startButton.addTarget(self, action: #selector(startBrowsing), for: .touchUpInside)
	}
	
	@objc
	private func startBrowsing(sender: UIButton) {
		if let appDel = UIApplication.shared.delegate as? AppDelegate {
			appDel.showBrowser()
		}
	}
}
