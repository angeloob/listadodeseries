//
//  ViewController.swift
//  Listado de Series
//
//  Created by Angel Olvera on 2/23/19.
//  Copyright © 2019 Angel Olvera. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/**
 clase que despliega una lista de series en la pantalla
 */
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    

    var showListData = [ShowBriefModel]()
    
    @IBOutlet weak var buscador: UISearchBar!
    @IBOutlet weak var menu: UICollectionView!
    
    /**
     actualiza la tabla cada vez que se escribe un caracter
 */
    private var searchResults = [JSON]() {
        didSet {
            menu.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var previousRun = Date()
    private let minInterval = 0.05
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ajustesBarraBusqueda()
        ajustesCollectionView(collection: menu)
    }
    
    func ajustesBarraBusqueda() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        buscador.placeholder = "Buscador de Series"
        definesPresentationContext = true
    }
    
   
    func ajustesCollectionView(collection: UICollectionView) {
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showListData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Celda", for: indexPath) as! PrincipalCollectionViewCell
        /**
         se asignan los valores en las respectivas variables
 */
        cell.titulo.text = showListData[indexPath.row].name
        let imageurl = showListData[indexPath.row].image
        
        Alamofire.request(imageurl!).responseData(completionHandler: { (response) in
            if response.error == nil{
                let img = UIImage(data: response.data!)
                cell.portada.image = img
            }
        }).validate(contentType: ["image/*"])
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizePantalla = UIScreen.main.bounds
        let ancho = (sizePantalla.width / 3.0) * 0.99
        let alto = (sizePantalla.height / 3.0) * 0.88
        return CGSize(width: ancho, height: alto)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tocaste: ", indexPath.row)
        performSegue(withIdentifier: "DetallesViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetallesViewController"{
            if let id = menu.indexPathsForSelectedItems?.first{
                let detalles = segue.destination as! DetallesViewController
                detalles.titulo = showListData[id.row].name!
                detalles.imageurl = showListData[id.row].image!
                detalles.descrip = showListData[id.row].summary!
                var day = "Horario: "
                if (showListData[id.row].days?.count)! > 0{
                    for index in 0 ... ((showListData[id.row].days?.count)! - 1){
                        day += (showListData[id.row].days?[index])!
                        
                        if index < ((showListData[id.row].days?.count)! - 1){
                            day += ", "
                        }
                    }
                }
                detalles.tiempo = day
                detalles.hora = showListData[id.row].time!
                detalles.sitio = showListData[id.row].sitio!
                detalles.id = showListData[id.row].id!
                detalles.caden = showListData[id.row].cadena!
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
 
    /**
     funcion que envia la cadena de caracteres a el URL para su busqueda en la Api
    */
    func fetchResults(for text: String) {
        print("Text Searched: \(text)")
        getShowList(sucessHandler: { (models) in
            self.showListData = models
            self.menu.reloadData()
        }, searchText: text, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                return
            }
            guard let results = results, !results.isEmpty else {
                return
            }
            self?.searchResults = results
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
    
    
    

}

