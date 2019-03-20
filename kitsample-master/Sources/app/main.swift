// import des differentes dependances
import Kitura
import KituraStencil
import Foundation

let router = Router()

//Creation objet message en fonction du formulaire dans Hello.stencil pour contenir les data envoyer
struct MessageContenue {
	var user : String
	var message : String
}

//Creation d'un tableau pour avoir les message un par un qui reste 
var SuperMessages = [MessageContenue]()

router.all(middleware: [BodyParser(), StaticFileServer(path: "./Public")])
router.add(templateEngine: StencilTemplateEngine())

//Affichage du formulaire
router.get("/chat") { request, response, next in
   try response.render("Hello.stencil",context : ["myMessage": SuperMessages])
   next()
}

router.post("/chat") { request, response, next in
//Recuperation des arguments du formulaire
let arguments = request.body?.asURLEncoded ?? [:]
    //Insertion des arguments dans des variables
    if let users = arguments["user"],
       let messages = arguments["message"]
    {
	//Si le champ user et messages ne sont pas vide alors
        if !users.isEmpty, !messages.isEmpty {
	    //myMessage prend les valeurs dans les champs user et message
            let myMessage = MessageContenue(user: users, message: messages)
	    //On insert le message myMessage dans le tableau SuperMessage au rang 0 
            SuperMessages.insert(myMessage, at: 0)
	    //Redirection sur le chat
            try response.redirect("http://localhost:8020/chat")
        } else { 
	     //Ici nous pourons gerer les erreur si le champ user et message sont vide 
        }
    } else { 
             //Ici nous pourons gerer l'evenement que soit un des champ soit vide 
    }
    next()
}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()
