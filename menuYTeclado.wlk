import FLDSMDFR.*
import levels.*

//*==========================| Controlador de Input |==========================
// Controlador de input que maneja el estado de los controles
object controlador {
    var controlesActivos = true
    
    method activarControles() {
        controlesActivos = true
    }
    
    method desactivarControles() {
        controlesActivos = false
    }
    
    method moverSiEsPosible(direccion) {
        if (controlesActivos) {
            player.mover(direccion)
        }
    }
}

//*==========================| Config Teclado |==========================
object configTeclado {
    var teclado = tecladoJuego

    method iniciar() {
        //* GAME ON:
        //Movimientos:
        keyboard.up().onPressDo({teclado.up()})
        keyboard.down().onPressDo({teclado.down()})
        keyboard.left().onPressDo({teclado.left()})
        keyboard.right().onPressDo({teclado.right()})

        //Reiniciar nivel:
        keyboard.r().onPressDo({teclado.r()})
    }

    method gameOn() {
        teclado = tecladoJuego
    }

    method gameBlocked() {
        teclado = tecladoBloqueado
    }
}

class TecladoBase {
    method up() {}
    method down() {}
    method left() {}
    method right() {}
    method r() {}
}

object tecladoJuego inherits TecladoBase {
    override method up() {
        controlador.moverSiEsPosible(arriba)
    }
    override method down() {
        controlador.moverSiEsPosible(abajo)
    }
    override method left() {
        controlador.moverSiEsPosible(izquierda)
    }
    override method right() {
        controlador.moverSiEsPosible(derecha)
    }
    override method r() {
        juegoFLDSMDFR.nivelActual().iniciar()
    }
}

object tecladoBloqueado inherits TecladoBase {
    // Todos los métodos quedan vacíos, bloqueando efectivamente el input
    override method r() {
        juegoFLDSMDFR.nivelActual().iniciar() // Solo permitimos reiniciar durante el bloqueo
    }
}

//*==========================| Sistema de Direcciones |==========================
// Sistema de direcciones usando Strategy Pattern
object arriba {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.up(1)
    }
    
    method opuesto() = abajo
}

object abajo {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.down(1)
    }
    
    method opuesto() = arriba
}

object izquierda {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.left(1)
    }
    
    method opuesto() = derecha
}

object derecha {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.right(1)
    }
    
    method opuesto() = izquierda
}