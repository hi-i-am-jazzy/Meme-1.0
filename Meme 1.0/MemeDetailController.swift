//
//  MemeDetailController.swift
//  Meme 1.0
//
//  Created by Jazmine Rodriguez on 6/22/20.
//  Copyright © 2020 Jazmine Rodriguez. All rights reserved.
//

import UIKit


class MemeDetailController: UIViewController {

    var meme: Meme? = nil
       
    @IBOutlet weak var memeImage: UIImageView!

    override func viewDidLoad() {
        memeImage.image = meme?.originalImage
    }
		
}
