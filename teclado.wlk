import levelDevil.*
import niveles.*

//          Gestor de Teclado
object gestorTeclado {
    var property configActual = configTecladoNormal
    
    method iniciarConfiguracionDeTeclas() {
        configActual.iniciar()
    }
    
    method cambiarConfiguracion(nuevaConfig) {
        configActual = nuevaConfig
        self.iniciarConfiguracionDeTeclas()
    }
    
    method juegoEnMarcha() {
        configActual.juegoEnMarcha()
    }
    
    method juegoBloqueado() {
        configActual.juegoBloqueado()
    }
}

//          Configuraciones de Teclado
class ConfigTecladoBase {
    var controlesHabilitados = true

    method iniciar() {
        keyboard.up().onPressDo({ self.mover(self.teclaArriba()) })
        keyboard.down().onPressDo({ self.mover(self.teclaAbajo()) })
        keyboard.left().onPressDo({ self.mover(self.teclaIzquierda()) })
        keyboard.right().onPressDo({ self.mover(self.teclaDerecha()) })
        keyboard.r().onPressDo({ gestorNiveles.reiniciarNivel() })
    }
    
    method teclaArriba() = arriba
    method teclaAbajo() = abajo
    method teclaIzquierda() = izquierda
    method teclaDerecha() = derecha

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

object configTecladoNormal inherits ConfigTecladoBase {}

object configTecladoInvertido inherits ConfigTecladoBase {
    override method teclaArriba() = abajo
    override method teclaAbajo() = arriba
    override method teclaIzquierda() = derecha
    override method teclaDerecha() = izquierda
}


//              Direcciones

class Movimiento {
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
