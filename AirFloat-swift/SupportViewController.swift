//
//  SupportViewController.swift
//  AirFloat-swift
//
//  Created by bestK1ng on 07/03/2019.
//

import UIKit

class SupportViewController: UITableViewController {

    fileprivate let originalGithubRepoLink = "https://github.com/trenskow/AirFloat"
    fileprivate let swiftGithubRepoLink = "https://github.com/bestK1ngArthur/AirFloat"
    fileprivate let originalContributorImageLink = "https://avatars3.githubusercontent.com/u/726715"
    fileprivate let swiftContributorImageLink = "https://avatars3.githubusercontent.com/u/9194359"
    fileprivate let originalContributorDonateLink = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=R59FM5PEGHT6E"
    fileprivate let swiftContributorDonateLink = "https://www.paypal.me/bestK1ng"
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var contributorsLabel: UILabel!
    
    @IBOutlet weak var originalContributorView: UIView!
    @IBOutlet weak var originalContributorImageView: UIImageView!
    @IBOutlet weak var originalContributorNameLabel: UILabel!
    @IBOutlet weak var originalContributorDescriptionLabel: UILabel!
    @IBOutlet weak var originalContributorDonateButton: UIButton!
    
    @IBOutlet weak var swiftContributorView: UIView!
    @IBOutlet weak var swiftContributorImageView: UIImageView!
    @IBOutlet weak var swiftContributorNameLabel: UILabel!
    @IBOutlet weak var swiftContributorDescriptionLabel: UILabel!
    @IBOutlet weak var swiftContributorDonateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    func initUI() {
        
        // Setup theme
        
        view.backgroundColor = AppTheme.current.backColor
        textLabel.textColor = AppTheme.current.textColor
        
        contributorsLabel.textColor = AppTheme.current.titleTextColor
        
        originalContributorImageView.backgroundColor = AppTheme.current.barColor
        swiftContributorImageView.backgroundColor = AppTheme.current.barColor
        
        originalContributorNameLabel.textColor = AppTheme.current.textColor
        originalContributorDescriptionLabel.textColor = AppTheme.current.textColor
        swiftContributorNameLabel.textColor = AppTheme.current.textColor
        swiftContributorDescriptionLabel.textColor = AppTheme.current.textColor
        
        originalContributorDonateButton.backgroundColor = AppTheme.current.tintTextColor
        swiftContributorDonateButton.backgroundColor = AppTheme.current.tintTextColor
        originalContributorDonateButton.setTitleColor(AppTheme.current.textColor, for: [])
        swiftContributorDonateButton.setTitleColor(AppTheme.current.textColor, for: [])
        
        // Add gestures
        
        let originalGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(originalContributorTapped))
        originalContributorView.addGestureRecognizer(originalGestureRecognizer)
        
        let swiftGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(swiftContributorTapped))
        swiftContributorView.addGestureRecognizer(swiftGestureRecognizer)
        
        // Set images
        
        setImage(for: originalContributorImageView, from: originalContributorImageLink)
        setImage(for: swiftContributorImageView, from: swiftContributorImageLink)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func originalDonateTapped(_ sender: Any) {
        openURL(string: originalContributorDonateLink)
    }
    
    @IBAction func swiftDonateTapped(_ sender: Any) {
        openURL(string: swiftContributorDonateLink)
    }
    
    @objc private func originalContributorTapped() {
        openURL(string: originalGithubRepoLink)
    }
    
    @objc private func swiftContributorTapped() {
        openURL(string: swiftGithubRepoLink)
    }
    
    private func openURL(string: String) {
        guard let url = URL(string: string) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func setImage(for imageView: UIImageView, from string: String, size: Int = 100) {
        guard let url = URL(string: "\(string)?s=\(size)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
