//
//  ListViewController.swift
//  MobDevLab1
//
//  Created by Dima on 19.02.2021.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searchArr = [Movie]()
    var searching = false
   
    lazy var jsonMovies = Manager.shared.getText("MoviesList", type: Movies.self)
    lazy var moviesArr:[Movie] = jsonMovies!.Search
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchArr.count
        } else {
            return moviesArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var movie: Movie?
        if searching {
            movie = searchArr[indexPath.row]
        } else {
            movie = moviesArr[indexPath.row]
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! CustomTableViewCell
        cell.setImageAndLabel(movie: movie!)
 
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showdetail") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if(moviesArr[indexPath.row].imdbID != "") {
                    let controller = segue.destination as! MovieDetailsViewController
                    var data: Movie?
                    // data = Manager.shared.getText(moviesArr[indexPath.row].imdbID, type: Movie.self)
                    if searching {
                        data = Manager.shared.getText(searchArr[indexPath.row].imdbID, type: Movie.self)
                    } else {
                        data = Manager.shared.getText(moviesArr[indexPath.row].imdbID, type: Movie.self)
                    }
                    
                    
                    controller.details = data
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            searching = false
            searchArr = [Movie]()
        } else {
            print(searchText)
            searchArr = moviesArr.filter(){$0.title.hasPrefix(searchText)}
            searching = true
        }
        self.tableView.reloadData()
    }
    
    
}
