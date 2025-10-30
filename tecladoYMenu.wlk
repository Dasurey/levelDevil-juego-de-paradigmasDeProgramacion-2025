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

class VisualSoloLectura {
    const property position

    var property image

    method ponerImagen(){
        game.addVisual(self)
    }
}

//          Configuraciones de Teclado
class ConfigTecladoBase {
    var controlesHabilitados = true

    method iniciar() {
        keyboard.up().onPressDo({ gestorDeJugadores.jugadorActual().estado().moverA(self.teclaArriba()) })
        keyboard.down().onPressDo({ gestorDeJugadores.jugadorActual().estado().moverA(self.teclaAbajo()) })
        keyboard.left().onPressDo({ gestorDeJugadores.jugadorActual().estado().moverA(self.teclaIzquierda()) })
        keyboard.right().onPressDo({ gestorDeJugadores.jugadorActual().estado().moverA(self.teclaDerecha()) })
        keyboard.r().onPressDo({ gestorNiveles.reiniciarNivel() })
    }
    
    method teclaArriba() = arriba
    method teclaAbajo() = abajo
    method teclaIzquierda() = izquierda
    method teclaDerecha() = derecha

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

object configTecladoDoble inherits ConfigTecladoBase {
    override method teclaArriba() = arriba.aplicarCantidad(2)
    override method teclaAbajo() = abajo.aplicarCantidad(2)
    override method teclaIzquierda() = izquierda.aplicarCantidad(2)
    override method teclaDerecha() = derecha.aplicarCantidad(2)
}

//              Direcciones

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
