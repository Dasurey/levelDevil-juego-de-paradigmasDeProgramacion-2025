import jugador.*

// Clase simple de pincho - único obstáculo
class Pincho {
    var property position = game.at(0, 0)
    
    method image() = "pincho.jpg"  // Usando la misma imagen que existe
    
    override method toString() = "Pincho en " + position.x() + "," + position.y()
}

// Meta simple del juego
class Meta {
    var property position = game.at(0, 0)

    method image() = "meta.jpg"  // Usando la misma imagen que existe por ahora

    override method toString() = "Meta en " + position.x() + "," + position.y()
}