//
//  MemeListViewController.swift
//  Meme 1.0
//
//  Created by Jazmine Rodriguez on 6/22/20.
//  Copyright © 2020 Jazmine Rodriguez. All rights reserved.
//

import UIKit

class MemeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView:UITableView!
    
    var memes:[Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table Cell")! as! MemeListViewCell
        let storedMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.previewImage.image = storedMeme.originalImage
        cell.previewText.text = storedMeme.topText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeSelected = memes?[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailController") as! MemeDetailController
        controller.meme = memeSelected
        navigationController?.pushViewController(controller, animated: true)
    }
}
