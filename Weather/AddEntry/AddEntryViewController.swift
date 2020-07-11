//
//  AddEntryViewController.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {

    var updateTextView: (() -> ())?

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addLabel.layer.cornerRadius = addLabel.layer.frame.height/2
    }

    @IBAction func addButton(_ sender: UIButton) {
        updateTextView?()

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddEntryViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.separator {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите текст записи..."
            textView.textColor = UIColor.separator
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
