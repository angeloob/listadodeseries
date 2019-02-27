import UIKit
import SwiftyJSON

class ShowDetailModel: NSObject {
    var id: Int?
    var name: String?
    var season: Int?
    var image: String?
    var summary: String?
    var episodio: Int?

    /**
     funcion que contiene los arreglos en donde se almascenará la información obtenida de la Api
     -json: arreglo json
     */
    func jsonMapper(json: JSON){
        id = json["id"].intValue
        episodio = json["number"].intValue
        print("episodio: ", episodio!)
        name = json["name"].stringValue
        season = json["season"].intValue
        print("season: ", season!)
        summary = json["summary"].stringValue
        image = json["image"]["original"].stringValue
    }
}

