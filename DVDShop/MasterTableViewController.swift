//
//  MasterTableViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 26.04.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//
import UIKit



// MARK: Wczytywanie danych zewnętrznych do obiektu

var filmList:FilmList = FilmList(filmsName: obrazki, titles: tytuly, actorsList: aktorzy, typeList: typyFilmow, descriptions: opisyFilmow, priceList: cenyFilmow, youtubeUrlList: youtubeUrls, likedList: polubienia)

class MasterTableViewController: UITableViewController {
    
//        let titles = ["Ostatni wojownik","Ogniem i mieczem","Jak zostać królem"]
        let actors = ["Bruce Lee","Dustin Hoffman","Harisson Ford"]
        let types = ["Science ficton","Horror","Komedia romantyczna"]
        let prices = ["22.50","17.99","34.40"]
    
    var film: TypeOfFilm = .horror
    
    let  dvdFilm: (picture: String, title: String, actors: String, type: TypeOfFilm, price: String) = (picture: "obrazek",  title: "tytul",  actors: "Aktorzy", type: .horror, price: "Cena")
    var dvdFilms = [(picture: String, title: String, actors: String, type: TypeOfFilm, price: String)]()
    
    var myDvd = ("aaa", "bbb", "cccc", TypeOfFilm.komedia)
    //let(panstwo,stolica)=stolicePanstw[IndexPath.item]
    
    func readSampleData() {
        for i in 1...obrazki.count{
            typyFilmow.append((i % 2 == 0) ? TypeOfFilm.sensacja : TypeOfFilm.obyczajowy)
            cenyFilmow.append((i % 2 == 0) ? 122.50 : 35.20)
            opisyFilmow.append("Super Film")
            aktorzy.append("Gal anonim")
            polubienia.append(false)
        }
        polubienia[1]=true
        polubienia[2]=true
        polubienia[5]=true
        polubienia[8]=true
        polubienia[14]=true
        polubienia[21]=true
        polubienia[35]=true
        polubienia[45]=true
        polubienia[82]=true
        polubienia[97]=true
        polubienia[109]=true
        
        

        
        print("=======polubienia========")
        for i in 0..<polubienia.count {
            if(polubienia[i]){
                listaUlubionych.append(i)
                print("element\(i)")
            }
        }
        
//        for i in 0..<polubienia.count {
//           zestawIcon.append(Icon(name: filmList.giveIcon(row: i).name, price: filmList.giveIcon(row: i).price, isFeatured: true))
//            print("zestawIcon name\(i)  \(zestawIcon[i].name)")
//            print("zestawIcon price\(i)  \(zestawIcon[i].price)")
//        }


        
        print("========")
        print("typyFilmow\(typyFilmow[0])")
        print("cenyFilmow\(cenyFilmow[0])")
        print("opisyFilmow\(opisyFilmow[0])")
        print("aktorzy\(aktorzy[0])")
        //print("typyFilmow\(typyFilmow)")
        //print("polubienia=\(polubienia)")
    
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readSampleData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return obrazki.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MasterTableViewCell

        // Configure the cell...
             
        let dane = filmList.give(row: indexPath.row)
        cell.DVDImage.image = dane.filmImage
        cell.titleLabel.text = dane.title
        cell.actorsLabel.text = dane.actors
        cell.typLabel.text = dane.type
        cell.priceLabel.text = dane.price    
        
        if dane.isLiked==true {
            cell.backgroundColor=UIColor.green
        }
        else
        {
            cell.backgroundColor=UIColor.clear
            //cell.seec
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    @IBAction  func unwindBeck(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            if segue.identifier=="showDvd" {
                if let indexPath=tableView.indexPathForSelectedRow {
                     let destinatonController = segue.destination as! DetailViewController
                    
                    destinatonController.dvdImageTmp   =  filmList.giveCurrentPictureName(row: indexPath.row)
                    destinatonController.titleLabelTmp =  filmList.give(row: indexPath.row).title
                    destinatonController.typeLabelTmp  =  filmList.give(row: indexPath.row).type
                    destinatonController.priceLabelTmp =  filmList.give(row: indexPath.row).price
                    destinatonController.youtubeUrlTmp =  filmList.give(row: indexPath.row).youtubeUrl
                    destinatonController.descriptionLabelTmp = filmList.give(row: indexPath.row).description
                }
            }
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Usuń"
    }
}
