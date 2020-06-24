//
//  ModuleDI.swift
//  Meme 1.0
//
//  Created by Jazmine Rodriguez on 6/23/20.
//  Copyright © 2020 Jazmine Rodriguez. All rights reserved.
//

import Foundation

class CacheMemeRepository: MemeRepository {
    
    var memes = [Meme]()

    func getAlll() -> [Meme] {
        return memes
    }
    
    func append(_ meme: Meme) {
        memes.append(meme)
    }
}


protocol MemeRepository {
    
    func getAlll() -> [Meme]
    
    func append(_ meme: Meme)

}

class ModuleDI {
    
    static var memeRepositoryInstance: MemeRepository? = nil
    
    static func providesMemeRepository() -> MemeRepository {
        if (memeRepositoryInstance == nil) {
            memeRepositoryInstance = CacheMemeRepository()
        }
        return memeRepositoryInstance!
    }
    
    
}

