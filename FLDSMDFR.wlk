import levels.*
import teclado.*

//        Configura el juego, arranca todo, inicializa teclado, etc.

object juegoFLDSMDFR {
    method iniciar() {
    game.title("FLDSMDFR")
    game.height(8)
    game.width(11)
    game.boardGround("fondo.jpg")

    configTeclado.iniciar()
    gestorNiveles.iniciarNivel()
}
}

//          Administra los niveles
object gestorNiveles {
    var property nivelActual = nivel1
    
    method iniciarNivel() {
        nivelActual.iniciar()
    }

    method siguienteNivel() {
        nivelActual = nivelActual.siguienteNivel()
        nivelActual.iniciar()
    }

    method clear() { 
        game.allVisuals().forEach { 
            visual => game.removeVisual(visual) 
        } 
    }

    method reiniciarNivel() {
        self.clear()
        nivelActual.iniciar()
        configTeclado.gameOn()   // Rehabilitar controles 
    }

}


//         Jugador principal
object player {
    var property position = game.at(0, 6)
    var property vidas = 1
    var property puntaje = 0
    const posicionInicial = game.at(0, 6)
    
    method image() = "zombie.png"

    method mover(direccion) {
        const nuevaPosicion = direccion.calcularNuevaPosicion(position)
        const objetos = game.getObjectsIn(nuevaPosicion)

        // Primero, interactuar con objetos de la celda destino
        objetos.forEach({objeto => objeto.interactuarConPersonaje(self)})

        // Verificar si hay pared
        const hayPared = objetos.any({ obj => obj.isA(Pared) })

        if (self.puedeMoverse(nuevaPosicion) and not hayPared) {
            // Mover al jugador
            position = nuevaPosicion
        } else if (hayPared) {
            game.say(self, "¡No puedes pasar por la pared!")
        }
    }




    
    method puedeMoverse(nuevaPosicion) {
        return nuevaPosicion.x().between(0, game.width() - 1) and nuevaPosicion.y().between(0, game.height() - 1)
    }
    
    method collideWith() {
        game.getObjectsIn(position).forEach({objeto => objeto.interactuarConPersonaje(self)}) //? Utilizamos esto como onCollideDo ya que on colide se saltea colisiones y va mas lento
    }
    
    method dead() {
    gestorNiveles.reiniciarNivel()  // delegás en el gestor lo que pasa al morir
    }

    
    method ganarPuntos(puntos) {
        puntaje += puntos
    }
    
    // Método necesario para el polimorfismo de interacciones
    method interactuarConPersonaje(pc) {
        // El player no hace nada especial al interactuar consigo mismo
    }
}

class Pincho {
    var property position = game.at(0, 0)
    
    method image() = "pincho.jpg"
    
    method interactuarConPersonaje(pc) {
        pc.dead()
    }
}

class Pared {
    var property position = game.at(0, 0)
    
    method image() = "muro.png"
    
    method interactuarConPersonaje(pc) {
    
    }
}

object pinchoInvisible {
    var property position = game.at(9,4) // posición final donde aparecerá
    var property visible = false          // inicial invisible
     method image() {
        if (visible) {
            return "pincho.jpg"
        } else {
            return null   // para q no se muestre nada
        }
    }
}

object caja {
  var property position = game.at(3,0)
  method image() = "caja.png"
  method movete() {
    const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0)
    // otra forma de generar números aleatorios
    // const x = (0.. game.width()-1).anyOne()
    // const y = (0.. game.height()-1).anyOne()
    position = game.at(x,y)
  }
}

class Meta {
    var property position = game.at(0, 0)

    method image() = "meta.jpg"
    
    method interactuarConPersonaje(pc) {
        pc.ganarPuntos(500)
        game.say(pc, "¡Nivel completado! Puntaje: " + pc.puntaje())
        
        // Pasar al siguiente nivel después de 2 segundos
        game.schedule(2000, {
            gestorNiveles.siguienteNivel()
        })
    }
}