//
//  DetallesViewController.swift
//  Listado de Series
//
//  Created by Angel Olvera on 2/25/19.
//  Copyright © 2019 Angel Olvera. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SafariServices

/**
 clase que muestra los detalles de la temporada seleccionada
 */
class DetallesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var showListTableView = UITableView()
    var showListData = [ShowDetailModel]()
    
    @IBOutlet weak var encabezado: UILabel!
    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var cadena: UILabel!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var dias: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var tabla: UITableView!
    
    
    var id: Int = 1
    var titulo = ""
    var imageurl = ""
    var descrip = ""
    var tiempo = ""
    var hora = ""
    var sitio = ""
    var caden = ""
    
    
    /**
     boton que despliega un nuevo view con el url de la serie
 */
    @IBAction func link(_ sender: UIButton) {
        guard let url = URL.init(string: sitio)
            else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda") as! temporadasTableViewCell
        /**
         guarda los arreglos en sus respectivas variables
 */
        let def = showListData[indexPath.row].summary
        
        cell.descripcion.text = def?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
        cell.season.text = showListData[indexPath.row].name
        print("temporada: ", cell.season.text!)
        
        let imageurl = showListData[indexPath.row].image
        /**
         llama el url de la imagen y lo asigna a un UIImage
 */
        Alamofire.request(imageurl!).responseData(completionHandler: { (response) in
            if response.error == nil{
                let img = UIImage(data: response.data!)
                cell.portada.image = img
            }
        }).validate(contentType: ["image/*"])
        //        cell.season.text = arreglo[indexPath.row]
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        /**
         prepara los valores recibidos de la clase anterior para desplegarlos en la pantalla
 */
        super.viewDidLoad()
        encabezado.text = titulo
        cadena.text = caden
        print("titulo:", encabezado.text!)
        descripcion.text = descrip.replacingOccurrences(of: "<p>" , with: " ").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        horario.text = "Días: " + hora
        dias.text = tiempo
        print("tiempo: ", tiempo)
        Alamofire.request(imageurl).responseData(completionHandler: { (response) in
            if response.error == nil{
                let img = UIImage(data: response.data!)
                self.portada.image = img
            }
        }).validate(contentType: ["image/*"])
        let idObtenido = id
        print("este es el id obtenido del arreglo", idObtenido)
        // Do any additional setup after loading the view.
        getSeasonList(id: id, sucessHandler: { (models) in
            print("id dentro de get: ", self.id)
            self.showListData = models
            self.showListTableView.reloadData()
            
            
        }) { (error) in
            print("salam")
            
        }
       showListTableView.reloadData()
    }
    

}
