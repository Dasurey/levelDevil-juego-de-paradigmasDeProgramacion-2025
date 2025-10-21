import levels.*
import teclado.*
import wollok.game.*

//        Configura el juego, arranca todo, inicializa teclado, etc.
object juegoFLDSMDFR {
    method iniciar() {
        game.title("FLDSMDFR")
        game.height(8)
        game.width(11)
        game.boardGround("fondo.jpg")

        // Configurar las colisiones con los pinchos
        game.onCollideDo(player, { elemento => elemento.interactuarConPersonaje(player) })

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
        game.allVisuals().forEach({ visual => game.removeVisual(visual) })
    }
    
    method reiniciarNivel() {
        self.clear()
        nivelActual.iniciar()
        configTeclado.gameOn() // Rehabilitar controles 
    }
}

//         Jugador principal
object player {
    var property position = game.at(0, 6)
    var property vidas = 1
    var property puntaje = 0
    
    method image() = "zombie-derecha.png"

    method mover(movimiento) {
        gestorNiveles.nivelActual().mover(self, movimiento)
    }

    method dead() {
        gestorNiveles.reiniciarNivel() // delegás en el gestor lo que pasa al morir
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
    
    method image() = "pincho_triple.png"

    method esPisable() = true
    
    method interactuarConPersonaje(pc) {
        pc.dead()
    }
}

class Pared {
    const property position
    
    method image() = "muro.png"

    //Colision
    method esPisable() = false

    method interactuarConPersonaje(pc){}
}

object pinchoInvisible {
    var property position = game.at(9, 4) // posición final donde aparecerá
    var property visible = false // inicial invisible
    method esPisable() = true

    method image() {
        if (visible) {
            return "pincho_triple.png"
        } else {
          return null // para q no se muestre nada
        }
    }

    method interactuarConPersonaje(pc) {
        pc.dead()
    }
}

object pinchoMovil {
    var property position = game.at(4, 3)
    method esPisable() = true

    method image() = "pincho_triple.png"

    method moverseAleatoriamente() {
        const direcciones = [arriba, abajo, izquierda, derecha]
        const direccionAleatoria = direcciones.anyOne()
        gestorNiveles.nivelActual().mover(self, direccionAleatoria)
    }

    // Método para interactuar con el jugador (igual que Pincho)
    method interactuarConPersonaje(pc) {
        pc.dead()
    }
}

object caja {
    var property position = game.at(3, 0)

    method image() = "caja.png"

    method esPisable() = false

    method movete() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        
        // otra forma de generar números aleatorios
        // const x = (0.. game.width()-1).anyOne()
        // const y = (0.. game.height()-1).anyOne()
        position = game.at(x, y)
    }
}

class Meta {
    var property position = game.at(0, 0)

    method image() = "meta.jpg"

    method esPisable() = true

    method interactuarConPersonaje(pc) {
        pc.ganarPuntos(500)
        configTeclado.gameBlocked() // deshabilita los controles
        
        game.say(pc, "¡Nivel completado! Puntaje: " + pc.puntaje())
        
        // Cambiamos de nivel después de 2 segundos
        game.schedule(2000, {
            gestorNiveles.siguienteNivel()
            // Rehabilitamos los controles después del cambio de nivel
            configTeclado.gameOn()
        })
    }
}