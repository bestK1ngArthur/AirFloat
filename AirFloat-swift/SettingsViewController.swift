//
//  SettingsViewController.swift
//  AirFloat-swift
//
//  Created by bestK1ng on 02/03/2019.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: TextField!
    
    @IBOutlet weak var authenticationLabel: UILabel!
    @IBOutlet weak var authenticationField: TextField!
    @IBOutlet weak var authenticationSwitch: UISwitch!
    
    @IBOutlet weak var playbackLabel: UILabel!
    @IBOutlet weak var playbackTitleLabel: UILabel!
    @IBOutlet weak var playbackSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        updateUI()
    }

    func initUI() {
        view.backgroundColor = AppTheme.current.backColor
        
        nameField.backgroundColor = AppTheme.current.barColor
        authenticationField.backgroundColor = AppTheme.current.barColor

        nameField.textColor = AppTheme.current.textColor
        authenticationField.textColor = AppTheme.current.textColor
        
        nameLabel.textColor = AppTheme.current.titleTextColor
        authenticationLabel.textColor = AppTheme.current.titleTextColor
        playbackLabel.textColor = AppTheme.current.titleTextColor
        playbackTitleLabel.textColor = AppTheme.current.textColor
        
        tableView.separatorColor = AppTheme.current.barColor
        tableView.tableFooterView = UIView()
        
        authenticationSwitch.onTintColor = AppTheme.current.tintTextColor
        playbackSwitch.onTintColor = AppTheme.current.tintTextColor

        authenticationSwitch.tintColor = AppTheme.current.barColor
        authenticationSwitch.thumbTintColor = AppTheme.current.barColor
        playbackSwitch.tintColor = AppTheme.current.barColor
        playbackSwitch.thumbTintColor = AppTheme.current.barColor
    }
    
    func updateUI() {
        let settings = AirPlayService.standart.settings
        
        nameField.text = settings.name
        
        authenticationSwitch.isOn = !settings.password.isEmpty
        authenticationField.text = settings.password
        
        playbackSwitch.isOn = settings.ignoreSourceVolume
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
        // Update settings
        
        let name = nameField.text ?? ""
        let password = authenticationField.text ?? ""
        
        let settings = AirPlaySettings(name: name, password: password, ignoreSourceVolume: playbackSwitch.isOn)
        AirPlayService.standart.updateSettings(settings)
    }
    
    @IBAction func authenticationChanged(_ sender: TextField) {
        authenticationSwitch.isOn = !(sender.text?.isEmpty ?? true)
    }
    
    @IBAction func authenticationSwitchChanged(_ sender: UISwitch) {
        
        if sender.isOn == false {
            authenticationField.text = nil
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
