import levelDevil.*
import niveles.*

//          Configuración del Teclado 

object configTeclado {
    var controlesHabilitados = true

    method iniciar() {
        keyboard.up().onPressDo({ self.mover(arriba) })
        keyboard.down().onPressDo({ self.mover(abajo) })
        keyboard.left().onPressDo({ self.mover(izquierda) })
        keyboard.right().onPressDo({ self.mover(derecha) })
        keyboard.r().onPressDo({ gestorNiveles.nivelActual.reiniciarNivel() })
    }

    method mover(direccion) {
        if (controlesHabilitados) {
            const nuevaPosition = direccion.calcularNuevaPosition(jugador.position())
            jugador.position(nuevaPosition)
        }
    }

    method juegoEnMarcha() {
        controlesHabilitados = true
    }

    method juegoBloqueado() {
        controlesHabilitados = false
    }
}


//              Direcciones

class Movimiento {
    method puedeMoverse(nuevaPosition) {
        // return nuevaPosition.x().between(0, game.width() - 1) and nuevaPosition.y().between(0, game.height() - 1)
        // Verificar que esté dentro de los límites del juego
        if (!nuevaPosition.x().between(0, game.width() - 1) or !nuevaPosition.y().between(0, game.height() - 1)) {
            return false
        }
        
        // Verificar que la posición tenga algún elemento válido para moverse
        return game.getObjectsIn(nuevaPosition).size() > 0
    }

    method validarPosition(position) = game.getObjectsIn(position).all({elem => elem.esPisable()}) && self.puedeMoverse(position)
    
    method calcularNuevaPosition(positionActual) {
        const nuevaPosition = self.moverEnDireccion(positionActual)
        if(self.validarPosition(nuevaPosition)){
            return nuevaPosition
        } else {
            return positionActual
        }
    }
    
    method moverEnDireccion(position)
}

object arriba inherits Movimiento {
    override method moverEnDireccion(position) = position.up(1)
}

object abajo inherits Movimiento {
    override method moverEnDireccion(position) = position.down(1)
}

object izquierda inherits Movimiento {
    override method moverEnDireccion(position) = position.left(1)
}

object derecha inherits Movimiento {
    override method moverEnDireccion(position) = position.right(1)
}
