//
//  ViewController.swift
//  BKG-Test
//
//  Created by Jay Bergonia on 16/8/2018.
//  Copyright © 2018 Tektos Limited. All rights reserved.
//

import UIKit
import MessageUI
import CocoaLumberjackSwift

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var activationLabel: UILabel!
    @IBOutlet weak var activationButton: UIButton!
    
    
    var fetchIsOff = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func activationBtnPressed(_ sender: UIButton) {
        
        if fetchIsOff {
            DDLogInfo(" TEST *** fetch Activated")
            fetchIsOff = false
            self.activationLabel.text = "Background Fetch: ON"
            self.activationButton.setTitle("DeActivate", for: .normal)
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        } else {
            DDLogInfo("fetch deActivated")
            fetchIsOff = true
            self.activationLabel.text = "Background Fetch: OFF"
            self.activationButton.setTitle("Activate", for: .normal)
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
        }
        
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            MFMailComposeViewController.canSendMail() == true
            else {
                return
        }
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject("Logs for BKG-Test!")
        mailCompose.setMessageBody("", isHTML: false)
        
        let logURLs = appDelegate.fileLogger.logFileManager.sortedLogFilePaths
            .map { URL.init(fileURLWithPath: $0, isDirectory: false) }
        
        var logsDict: [String: Data] = [:] // File Name : Log Data
        logURLs.forEach { (fileUrl) in
            guard let data = try? Data(contentsOf: fileUrl) else { return }
            logsDict[fileUrl.lastPathComponent] = data
        }
        
        for (fileName, logData)  in logsDict {
            mailCompose.addAttachmentData(logData, mimeType: "text/plain", fileName: fileName)
        }
        
        present(mailCompose, animated: true, completion: nil)
    }
    
    
    
    
}

