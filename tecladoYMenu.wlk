import levelDevil.*
import niveles.*

// Configuraciones de Teclado
object configTeclado {
    var teclado = tecladoNormal

    method teclado(nuevoTeclado) { 
        teclado = nuevoTeclado
    }

    var controlesHabilitados = true

    method controlesHabilitados() = controlesHabilitados

    method iniciar() {
        keyboard.up().onPressDo({ teclado.up() })
        keyboard.down().onPressDo({ teclado.down() })
        keyboard.left().onPressDo({ teclado.left() })
        keyboard.right().onPressDo({ teclado.right() })
        keyboard.r().onPressDo({ teclado.r() })
    }

    method juegoEnMarcha() {
        controlesHabilitados = true
    }

    method juegoBloqueado() {
        controlesHabilitados = false
    }
}

class TecladoBase{
    method up(){}
    method down(){}
    method left(){}
    method right(){}

    method r(){}
    method m(){}
}

object tecladoNormal inherits TecladoBase {
    override method up(){gestorDeJugadores.moverA(arriba)}
    override method down(){gestorDeJugadores.moverA(abajo)}
    override method left(){gestorDeJugadores.moverA(izquierda)}
    override method right(){gestorDeJugadores.moverA(derecha)}

    override method r(){gestorNiveles.reiniciarNivel()}
}

object tecladoInvertido inherits TecladoBase {
    override method up(){gestorDeJugadores.moverA(abajo)}
    override method down(){gestorDeJugadores.moverA(arriba)}
    override method left(){gestorDeJugadores.moverA(derecha)}
    override method right(){gestorDeJugadores.moverA(izquierda)}

    override method r(){gestorNiveles.reiniciarNivel()}
}

object tecladoDoble inherits TecladoBase {
    override method up(){gestorDeJugadores.moverA(arriba.aplicarCantidad(2))}
    override method down(){gestorDeJugadores.moverA(abajo.aplicarCantidad(2))}
    override method left(){gestorDeJugadores.moverA(izquierda.aplicarCantidad(2))}
    override method right(){gestorDeJugadores.moverA(derecha.aplicarCantidad(2))}

    override method r(){gestorNiveles.reiniciarNivel()}
}

// Direcciones
class Movimiento {
    var property cantidadPositions = 1

    method puedeMoverse(position) {
        // Verificar que esté dentro de los límites del juego
        if (!position.x().between(0, game.width() - 1) or !position.y().between(0, game.height() - 1)) {
            return false
        }
        return game.getObjectsIn(position).size() > 0
    }

    method validarPosition(position) = self.puedeMoverse(position) and game.getObjectsIn(position).all({elem => elem.esPisable()}) 
    
    method calcularNuevaPosition(positionActual) {
        const nuevaPosition = self.moverEnDireccion(positionActual)
        if(self.validarPosition(nuevaPosition)){
            return nuevaPosition
        } else {
            return positionActual
        }
    }
    
    method moverEnDireccion(position)

    method aplicarCantidad(cantidad) {
        cantidadPositions = cantidad
        return self
    }
}

object arriba inherits Movimiento {
    override method moverEnDireccion(position) = position.up(cantidadPositions)
}

object abajo inherits Movimiento {
    override method moverEnDireccion(position) = position.down(cantidadPositions)
}

object izquierda inherits Movimiento {
    override method moverEnDireccion(position) = position.left(cantidadPositions)
}

object derecha inherits Movimiento {
    override method moverEnDireccion(position) = position.right(cantidadPositions)
}
