//
//  SearchGameController.swift
//  MyIVR
//
//  Created by Андрей Хромов on 24/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class SearchGameController: UIViewController {
    var playersInfo = [1,1]

    @IBOutlet weak var tableView: UITableView!
    var games = [Game]()
    var numberGame = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        // getGames()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchFourSegue"{
            if let vc = segue.destination as? FourPlayersGame {
                vc.rait = Int(games[numberGame].rait)!
                vc.game = games[numberGame]
            }
        }
    }
    
    
    // MARK: - Navigation

    func getGames() {
        DataService.instance.searchGame { (games) in
            self.games = games
            self.tableView.reloadData()
        }
    }
}
extension SearchGameController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell")!
        cell.textLabel?.text = "Моя игра"
        cell.detailTextLabel?.text = "1"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numberGame = indexPath.row
        self.performSegue(withIdentifier: "SearchFourSegue", sender: nil)
    }
    
    
}

