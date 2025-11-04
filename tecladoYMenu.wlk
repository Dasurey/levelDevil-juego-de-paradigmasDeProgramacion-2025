import levelDevil.*
import niveles.*
import visualizadores.*

object menu {
    method iniciar(){
        juegoLevelDevil.detenerMovimientos()
        juegoLevelDevil.limpiar()

        self.dibujarMenu()

        configTeclado.menuAbierto()
    }
    
    method dibujarMenu(){
        new VisualSoloLectura(image = "Logo_V1.png", position = game.at(8, 7)).ponerImagen()
        menuDePersonaje.iniciar()
    }
}

object menuDePersonaje {
    var property position = game.at(7, 4)
    var menuElegirPersonajesEstaAbierto = false
    const imagenes = ["MenuCerrado.png", "MenuDePersonajes_V2.png"]
    var imagen = imagenes.first()
    
    method image() = imagen
    
    method iniciar(){
        juegoLevelDevil.detenerMovimientos()
        position = game.at(7, 4)
        game.addVisual(self)
        configTeclado.menuAbierto()
        menuElegirPersonajesEstaAbierto = false
        imagen = imagenes.first()
    }

    method desplegar() = if(menuElegirPersonajesEstaAbierto) self.cerrar() else self.abrir()

    method cerrar(){
        juegoLevelDevil.detenerMovimientos()
        position = game.at(7, 4)
        imagen = imagenes.first()
        configTeclado.menuAbierto()
        menuElegirPersonajesEstaAbierto = false
    }

    method abrir(){
        juegoLevelDevil.detenerMovimientos()
        juegoLevelDevil.limpiar()
        position = game.at(0,0)
        imagen = imagenes.last()
        game.addVisual(self)
        configTeclado.menuAbiertoElegirPersonajes()
        menuElegirPersonajesEstaAbierto = true
    }
}

// Configuraciones de Teclado
object configTeclado {
    var teclado = tecladoNormal

    method cambiarTecladoA(nuevoTeclado) { 
        teclado = nuevoTeclado
    }

    method iniciar() {
        keyboard.up().onPressDo({ teclado.up() })
        keyboard.down().onPressDo({ teclado.down() })
        keyboard.left().onPressDo({ teclado.left() })
        keyboard.right().onPressDo({ teclado.right() })

        keyboard.r().onPressDo({ teclado.r() })
        keyboard.m().onPressDo({ teclado.m() })

        keyboard.j().onPressDo({ teclado.j() })
        keyboard.p().onPressDo({ teclado.p() })

        keyboard.num1().onPressDo({ teclado.num1() })
        keyboard.num2().onPressDo({ teclado.num2() })
        keyboard.num3().onPressDo({ teclado.num3() })
        keyboard.num4().onPressDo({ teclado.num4() })
    }

    method juegoEnMarcha() {
        teclado = tecladoNormal
    }

    method menuAbierto() {
        teclado = tecladoMenu
    }

    method menuAbiertoElegirPersonajes() {
        teclado = tecladoMenuElegirPersonajes
    }

    method juegoBloqueado() {
        teclado = tecladoBase
    }
}

class TecladoBase {
    method up() {}
    method down() {}
    method left() {}
    method right() {}

    method r() {}
    method m() {}

    method j() {}
    method p() {}

    method num1() {}
    method num2() {}
    method num3() {}
    method num4() {}
}

object tecladoBase inherits TecladoBase {}

class TecladoMenu inherits TecladoBase {
    override method j() {
        juegoLevelDevil.iniciarNivel()
    }

    override method p() {
        menuDePersonaje.desplegar()
    }
}

object tecladoMenu inherits TecladoMenu {}

object tecladoMenuElegirPersonajes inherits TecladoBase {
    override method num1() {
        juegoLevelDevil.volverAIniciarDeCero(jugadorLevelDevil)
    }

    override method num2() {
        juegoLevelDevil.volverAIniciarDeCero(zombie)
    }

    override method num3() {
        juegoLevelDevil.volverAIniciarDeCero(miniMessi)
    }

    override method num4() {
        juegoLevelDevil.volverAIniciarDeCero(satoruGojo)
    }
}

object tecladoNormal inherits TecladoBase {
    override method up() { gestorDeJugadores.moverA(arriba) }
    override method down() { gestorDeJugadores.moverA(abajo) }
    override method left() { gestorDeJugadores.moverA(izquierda) }
    override method right() { gestorDeJugadores.moverA(derecha) }

    override method r() { juegoLevelDevil.reiniciarNivel() }
    override method m() {  menu.iniciar() }
}

object tecladoInvertido inherits TecladoBase {
    override method up() { gestorDeJugadores.moverA(abajo) }
    override method down() { gestorDeJugadores.moverA(arriba) }
    override method left() { gestorDeJugadores.moverA(derecha) }
    override method right() { gestorDeJugadores.moverA(izquierda) }

    override method r() { juegoLevelDevil.reiniciarNivel() }
    override method m() {  menu.iniciar() }
}

object tecladoEnManesillasDeReloj inherits TecladoBase {
    override method up() { gestorDeJugadores.moverA(derecha) }
    override method right() { gestorDeJugadores.moverA(abajo) }
    override method down() { gestorDeJugadores.moverA(izquierda) }
    override method left() { gestorDeJugadores.moverA(arriba) }

    override method r() { juegoLevelDevil.reiniciarNivel() }
    override method m() {  menu.iniciar() }
}

/*
object tecladoDoble inherits TecladoBase {
    override method up() { gestorDeJugadores.moverA(arriba.cantidadDeMovimientos(2)) }
    override method down() { gestorDeJugadores.moverA(abajo.cantidadDeMovimientos(2)) }
    override method left() { gestorDeJugadores.moverA(izquierda.cantidadDeMovimientos(2)) }
    override method right() { gestorDeJugadores.moverA(derecha.cantidadDeMovimientos(2)) }

    override method r() { juegoLevelDevil.reiniciarNivel() }
    override method m() {  menu.iniciar() }
}
*/

// Direcciones
class Movimiento {
    //var movimientosQueDaElPersonaje = 1

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

    /*
    method cantidadDeMovimientos(cantidad) {
        movimientosQueDaElPersonaje = cantidad
        return self
    }
    */
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
