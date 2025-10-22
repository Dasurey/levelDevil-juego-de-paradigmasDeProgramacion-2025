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
            jugador.mover(direccion)
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


object arriba {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.up(1)
    }
}

object abajo {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.down(1)
    }
}

object izquierda {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.left(1)
    }
}

object derecha {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.right(1)
    }
}
