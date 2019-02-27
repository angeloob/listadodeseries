import UIKit
import SwiftyJSON

class ShowBriefModel: NSObject {
    var id: Int?
    var image: String?
    var name: String?
    var summary: String?
    var time: String?
    var days: [String]?
    var sitio: String?
    var cadena: String?
    
    /**
     funcion que contiene los arreglos en donde se almascenará la información obtenida de la Api
     -json: arreglo json 
 */
    func jsonMapper(json: JSON){
        id = json["show"]["id"].intValue
        print("este es el id: ", id!)
        image = json["show"]["image"]["medium"].stringValue
        print("este es la imagen: ", image!)
        name = json["show"]["name"].stringValue
        print("este es el nombre: ", name!)
        summary = json["show"]["summary"].stringValue 
        time = json["show"]["schedule"]["time"].stringValue
        days = json["show"]["schedule"]["days"].arrayObject as? [String]
        sitio = json["show"]["officialSite"].stringValue
        cadena = json["show"]["network"]["name"].stringValue
    }
}
