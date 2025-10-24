import niveles.*
import teclado.*

//        Configura el juego, arranca todo, inicializa teclado, etc.
object juegoLevelDevil {
    method iniciar() {
        game.title("Level Devil")
        game.height(12)
        game.width(24)
        game.boardGround("fondo.jpg")

        // Configurar las colisiones con los pinchos
        game.onCollideDo(jugador, { elemento => elemento.interactuarConPersonaje(jugador) })

        configTeclado.iniciar()
        gestorNiveles.iniciarNivel()
    }
}

//         Jugador principal
object jugador {
    var property position = game.at(0, 6)
    var property vidas = 1
    var property puntaje = 0
    
    method image() = "zombie-derecha.png"
    
    method esPisable() = true

    method morir() {
        vidas -= 1
        if (vidas <= 0) {
            game.say(self, "¡Has perdido todas tus vidas! Juego terminado.")
            gestorNiveles.reiniciarNivel() // delegás en el gestor lo que pasa al morir
        } else {
            game.say(self, "¡Has perdido una vida! Vidas restantes: " + vidas)
        }
    }
    
    method ganarPuntos(puntos) {
        puntaje += puntos
    }
}

class ObjetoMorible {
    var property position
    
    method image()

    method esPisable() = true

    method interactuarConPersonaje(pj) {
        pj.morir()
    }
}

class Pincho inherits ObjetoMorible {    
    override method image() = "pincho_triple.png"
}

class PinchoInvisible inherits ObjetoMorible {
    var property visible = false // comienza invisible

    // La imagen depende de la propiedad 'visible'
    override method image() {
        if (visible) {
            return "pincho_triple.png"
        } else {
            return null
        }
    }

    method hacerVisible() {
        // Genero un id por instancia para no pisar otros onTick
        const tickId = "mostrarPincho_" + self.position().x() + "_" + self.position().y()
        game.onTick(100, tickId, {
            const dx = (jugador.position().x() - self.position().x()).abs()
            const dy = (jugador.position().y() - self.position().y()).abs()

            // Si el jugador está cerca, marcamos visible el pincho
            if (dx <= 1 and dy <= 1) {
                visible = true
            }
        })
    }
}

class PinchoMovil inherits ObjetoMorible {
    const tickId = "moverPinchoMovil_" + self.identity()
    
    override method image() = "pincho_triple.png"

    method moverseAleatoriamente() {
        const direcciones = [arriba, abajo, izquierda, derecha]
        const direccionAleatoria = direcciones.anyOne()
        position = direccionAleatoria.calcularNuevaPosition(position)
    }

    method moverPinchoMovil() {
        // el pincho cada se mueve cada 0,3 seg
        game.onTick(300, tickId, {
            self.moverseAleatoriamente()
        })
    }
    
    method detenerMovimiento() {
        game.removeTickEvent(tickId)
    }
}

class Pared {
    const property position
    
    method image() = "Muro1.png"

    //Colision
    method esPisable() = false

    method interactuarConPersonaje(pj){}
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

    method interactuarConPersonaje(pj) {
        // Detener todos los PinchosMovil
        game.allVisuals()
            .filter({ visual => visual.toString().contains("PinchoMovil") })
            .forEach({ pinchoMovil => pinchoMovil.detenerMovimiento() })

        pj.ganarPuntos(500)
        configTeclado.juegoBloqueado() // deshabilita los controles
        
        game.say(pj, "¡Nivel completado! Puntaje: " + pj.puntaje())
        
        // Cambiamos de nivel después de 2 segundos
        game.schedule(2000, {
            gestorNiveles.siguienteNivel()
            // Rehabilitamos los controles después del cambio de nivel
            configTeclado.juegoEnMarcha()
        })
    }
}
