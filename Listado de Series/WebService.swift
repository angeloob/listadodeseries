import Foundation
/**
 Libreria que ayuda a gestionar tareas de red
 */
import Alamofire
import SwiftyJSON
/**
 result type para enviar un estado en caso de haber o no haber conexion con el servidor
 */
enum NetworkError: Error {
    case failure
    case success
}


var baseURL = "http://api.tvmaze.com/shows"

typealias getShowListsuccessHandler = ([ShowBriefModel]) -> Void
typealias errorHandler = (String?) -> Void
typealias getDetailSuccessHandler = ([ShowDetailModel]) -> Void


/**
   detShowList es la funcion que lee el Api
 -succesHandler: valores que va a buscar en la api
 -errorHandler: recibe un valor tipo cadena en caso de que no tenga exito con la comunicacion de la clase.
 -completionHandler: Cuando se pasa un closure como argumento de la función, el cierre se conserva para ejecutarse más tarde y el cuerpo de la función se ejecuta y devuelve el compilador.
 */
func getShowList(sucessHandler: getShowListsuccessHandler? = nil, errorHandler: errorHandler? = nil, searchText: String, completionHandler: @escaping ([JSON]?, NetworkError) -> ()){
    let baseURL = "http://api.tvmaze.com/search/shows?q=\(searchText)"
    /**
    se obvitenen los valores de la api requeridos y se guardan en un arreglo
 */
    Alamofire.request(baseURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        switch response.result{
        case .success(let value):
            let json = JSON(value)
            var successModels = [ShowBriefModel]()
            for jsonIndex in 0 ... (json.count){
                let tempModel = ShowBriefModel()
                tempModel.jsonMapper(json: json[jsonIndex])
                successModels.append(tempModel)
            }
            sucessHandler?(successModels)
            
            
        case .failure(let error):
            print(error)
            errorHandler?("\(error)")
        }
    }
}


/**
 detSeasonList es la funcion que lee el Api
 -id: valor entero que se recibe para enviarlo a la url
 -succesHandler: valores que va a buscar en la api
 -errorHandler: recibe un valor tipo cadena en caso de que no tenga exito con la comunicacion de la clase.
 */
func getSeasonList(id: Int, sucessHandler: getDetailSuccessHandler? = nil, errorHandler: errorHandler? = nil){
    Alamofire.request(baseURL + "/\(id)/episodes", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        switch response.result{
        case .success(let value):
            let json = JSON(value)
            var successModels = [ShowDetailModel]()
            for jsonIndex in 0 ... (json.count - 1){
                let tempModel = ShowDetailModel()
                tempModel.jsonMapper(json: json[jsonIndex])
                print("tempmodel: ", tempModel.jsonMapper(json: json[jsonIndex]))
                successModels.append(tempModel)
            }
            sucessHandler?(successModels)
        case .failure(let error):
            print(error)
            errorHandler?("\(error)")
        }
    }
}
