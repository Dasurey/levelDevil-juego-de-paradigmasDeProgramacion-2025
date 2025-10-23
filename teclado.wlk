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
        keyboard.r().onPressDo({ self.reiniciarNivel() })
    }

    method mover(direccion) {
        if (controlesHabilitados) {
            direccion.mover(jugador)
        }
    }

    method reiniciarNivel() {
        gestorNiveles.nivelActual().iniciar()
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
    method puedeMoverse(nuevaposition) {
        return nuevaposition.x().between(0, game.width() - 1) and nuevaposition.y().between(0, game.height() - 1)
    }

    method validarPosition(position) = game.getObjectsIn(position).all({elem => elem.esPisable()}) && self.puedeMoverse(position)
}

object arriba inherits Movimiento {
    method calcularNuevaposition(positionActual) {
        const nuevaPosition = positionActual.up(1)
        if(self.validarPosition(nuevaPosition)){
            return nuevaPosition
        } else {
            return positionActual
        }
    }
}

object abajo inherits Movimiento {
    method calcularNuevaposition(positionActual) {
        const nuevaPosition = positionActual.down(1)
        if(self.validarPosition(nuevaPosition)){
            return nuevaPosition
        } else {
            return positionActual
        }
    }
}

object izquierda inherits Movimiento {
    method calcularNuevaposition(positionActual) {
        const nuevaPosition = positionActual.left(1)
        if(self.validarPosition(nuevaPosition)){
            return nuevaPosition
        } else {
            return positionActual
        }
    }
}

object derecha inherits Movimiento {
    method calcularNuevaposition(positionActual) {
        const nuevaPosition = positionActual.right(1)
        if(self.validarPosition(nuevaPosition)){
            return nuevaPosition
        } else {
            return positionActual
        }
    }
}
