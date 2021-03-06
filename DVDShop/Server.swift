//
//  Server.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 16.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import UIKit
class Server {
    
    var urlString: String = ""
    var pictureUrlString = ""
    var url: URL? = nil
    var urlRequest:URLRequest? = nil
    var task: URLSession? = nil
    var dvds = [Dvd]()
    
    init() {
        self.urlString = "http://skurczewski1.myqnapcloud.com/dvdshop/api.php/dvds/"
        self.pictureUrlString = "http://skurczewski1.myqnapcloud.com/dvdshop/img/"
        getLatestDvds()
    }
    
    func getLatestDvds() {
        guard let url = URL(string: urlString) else {
            return        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler:
        { (data, response, error) -> Void in
            print("url:\(self.urlString)")
            if let error = error {
                print(error)
                return   }
            // Parse JSON data
            if let data = data {
                self.dvds = self.parseJsonData(data: data)
                }
            }
        )
    task.resume()
    }


    func parseJsonData(data: Data) -> [Dvd] {
           var dvds = [Dvd]()
           do {
                 let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    // Parse JSON data
                    let jsonDvds = jsonResult?["dvds"] as! [AnyObject]
                    for jsonDvd in jsonDvds {
                        let dvd = Dvd()
                        
                        dvd.actors          = jsonDvd["title"] as! String
                        dvd.filmDescription = jsonDvd["filmDescription"] as! String
                        dvd.filmDirector    = jsonDvd["filmDirector"] as! String
                        dvd.filmId          = jsonDvd["filmId"] as! String
                        dvd.filmImageName   = jsonDvd["filmImageName"] as! String
                        dvd.filmImageData   =  getPictureWeb(pictureName: dvd.filmImageName)
                        dvd.isLiked         = (jsonDvd["isLiked"] as! String)=="1" ? true : false
                        dvd.price           = jsonDvd["price"] as! String
                        dvd.title           = jsonDvd["title"] as! String
                        dvd.type            = jsonDvd["type"] as! String
                        dvd.youtubeUrl      = jsonDvd["youtubeUrl"] as! String
                        dvds.append(dvd)
                    }
                } catch {    print(error)     }
        return dvds
     }
    
    func makeJsonTxt(database db : Database) -> String {
        var tekst: String = ""
        var tx: [String] = ["","","","","","","","","","",""]
        let brak = "brak"
        
        tekst =  "{ \"dvds\" : ["
        for i in 0..<db.flimsbaseFull.count  {
            tx[0] = "  {\"filmId\":\"\(db.flimsbaseFull[i].filmId ??  brak)\""
            tx[1] = ", \"title\":\"\(db.flimsbaseFull[i].title ?? "")\""
            tx[2] = ", \"filmDirector\":\"\(db.flimsbaseFull[i].filmDirector ?? "")\""
            tx[3] = ", \"actors\":\"\(db.flimsbaseFull[i].actors ?? "")\""
            tx[4] = ", \"type\":\"\(db.flimsbaseFull[i].type ?? "")\""
            tx[5] = ", \"filmDescription\":\"\(db.flimsbaseFull[i].filmDescription ?? "")\""
            tx[6] = ", \"filmImageName\":\"\(db.flimsbaseFull[i].pictureName ?? "")\""
            tx[7] = ", \"youtubeUrl\":\"\(db.flimsbaseFull[i].youtubeUrl ?? "")\""
            tx[8] = ", \"price\":\"\(db.flimsbaseFull[i].price )\""
            tx[9] = ", \"isLiked\":\"\(db.flimsbaseFull[i].isLiked ? "1" : "0")\"}"
            tx[10] = (i < db.flimsbaseFull.count-1) ? ",  \n " : " \n"
            for t in 0..<tx.count {
                tekst += tx[t]
            }
        }
        tekst += "]}"
        return tekst
    }
    
    func makeSqlTxt(database db : Database) -> String  {
        var tekst: String = ""
        var tx: [String] = ["","","","","","","",""]
        let brak = "brak"
        
        tekst =  "INSERT INTO `dvds` (`filmId`, `title`, `filmDirector`, `actors`, `type`, `filmDescription`, `filmImageName`, `youtubeUrl`, `price`, `isLiked`) VALUES \n"

        for i in 0..<db.flimsbaseFull.count  {
            tx[0] = db.flimsbaseFull[i].filmId ??  brak
            tx[1] = db.flimsbaseFull[i].title ?? ""
            tx[2] = db.flimsbaseFull[i].filmDirector ?? ""
            tx[3] = db.flimsbaseFull[i].actors ?? ""
            tx[4] = db.flimsbaseFull[i].type ?? ""
            tx[5] = db.flimsbaseFull[i].filmDescription ?? ""
            tx[6] = db.flimsbaseFull[i].pictureName ?? ""
            tx[7] = db.flimsbaseFull[i].youtubeUrl ?? ""            
            print("SQL picName:"+db.flimsbaseFull[i].pictureName!)
            
            tekst += "("           
            for t in 0..<tx.count {
                tekst += "'\(tx[t])', "
            }
            tekst += kantor.doubleToString(db.flimsbaseFull[i].price)+", "
            tekst += db.flimsbaseFull[i].isLiked ? "1" : "0"
            tekst += (i < db.flimsbaseFull.count-1) ? "),  \n " : "); \n"
         }
        return tekst
    }
    
    func getPictureWeb(pictureName: String) -> Data? {
        var data:Data?
        let url = URL(string: "\(pictureUrlString)\(pictureName).jpg")
        
        do {  data = try Data(contentsOf: url!)
        } catch {
            data = nil
            if let img = UIImage(named: "placeholder.jpg"){
                 data = UIImagePNGRepresentation(img)
            }
        }
        return data
    }
    
    func fillDatabaseFromWeb() {
    
    }

}
