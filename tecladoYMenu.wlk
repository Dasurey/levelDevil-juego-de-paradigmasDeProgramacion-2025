import levelDevil.*
import niveles.*
import visualizadores.*

object menu{
    method iniciar(){
        juegoLevelDevil.limpiar()

        self.dibujarMenu()

        configTeclado.menuAbierto()
    }
    
    method dibujarMenu(){
        new VisualSoloLectura(image = "Logo_V1.png", position = game.at(8, 7)).ponerImagen()
        menuPersonaje.iniciar()
    }
}

object menuPersonaje {
    var property position = game.at(7, 4)
    var menuElegirPersonajesEstaAbierto = false
    const imagenes = ["MenuCerrado.png", "Personajes.png"]
    var imagen = imagenes.first()
    
    method image() = imagen
    
    method iniciar(){
        position = game.at(7, 4)
        game.addVisual(self)
        configTeclado.menuAbierto()
        menuElegirPersonajesEstaAbierto = false
        imagen = imagenes.first()
    }

    method desplegar() = if(menuElegirPersonajesEstaAbierto) self.cerrar() else self.abrir()

    method cerrar(){
        position = game.at(7, 4)
        imagen = imagenes.first()
        configTeclado.menuAbierto()
        menuElegirPersonajesEstaAbierto = false
    }

    method abrir(){
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

    var controlesHabilitados = true

    method controlesHabilitados() = controlesHabilitados

    const tecladoMenu = new TecladoMenu()

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

    method controlesEnMarcha() {
        controlesHabilitados = true
    }

    method controlesBloqueados() {
        controlesHabilitados = false
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

class TecladoMenu inherits TecladoBase {
    override method j() {
        gestorNiveles.iniciarNivel()
    }

    override method p() {
        menuPersonaje.desplegar()
    }
}

object tecladoMenuElegirPersonajes inherits TecladoBase {
    override method num1() {
        gestorDeJugadores.resetearPuntaje()
        gestorDeJugadores.reiniciarVidas()
        gestorDeJugadores.seleccionarPersonaje(jugadorLevelDevil)
        gestorNiveles.nivelActual(nivel1)
        gestorNiveles.iniciarNivel()
    }

    override method num2() {
        gestorDeJugadores.resetearPuntaje()
        gestorDeJugadores.reiniciarVidas()
        gestorDeJugadores.seleccionarPersonaje(zombie)
        gestorNiveles.nivelActual(nivel1)
        gestorNiveles.iniciarNivel()
    }

    override method num3() {
        gestorDeJugadores.resetearPuntaje()
        gestorDeJugadores.reiniciarVidas()
        gestorDeJugadores.seleccionarPersonaje(miniMessi)
        gestorNiveles.nivelActual(nivel1)
        gestorNiveles.iniciarNivel()
    }

    override method num4() {
        gestorDeJugadores.resetearPuntaje()
        gestorDeJugadores.reiniciarVidas()
        gestorDeJugadores.seleccionarPersonaje(satoruGojo)
        gestorNiveles.nivelActual(nivel1)
        gestorNiveles.iniciarNivel()
    }
}

object tecladoNormal inherits TecladoBase {
    override method up() { gestorDeJugadores.moverA(arriba.aplicarCantidad(1)) }
    override method down() { gestorDeJugadores.moverA(abajo.aplicarCantidad(1)) }
    override method left() { gestorDeJugadores.moverA(izquierda.aplicarCantidad(1)) }
    override method right() { gestorDeJugadores.moverA(derecha.aplicarCantidad(1)) }

    override method r() { gestorNiveles.reiniciarNivel() }
    override method m() { menu.iniciar() }
}

object tecladoInvertido inherits TecladoBase {
    override method up() { gestorDeJugadores.moverA(abajo.aplicarCantidad(1)) }
    override method down() { gestorDeJugadores.moverA(arriba.aplicarCantidad(1)) }
    override method left() { gestorDeJugadores.moverA(derecha.aplicarCantidad(1)) }
    override method right() { gestorDeJugadores.moverA(izquierda.aplicarCantidad(1)) }

    override method r() { gestorNiveles.reiniciarNivel() }
    override method m() { menu.iniciar() }
}

object tecladoDoble inherits TecladoBase {
    override method up() { gestorDeJugadores.moverA(arriba.aplicarCantidad(2)) }
    override method down() { gestorDeJugadores.moverA(abajo.aplicarCantidad(2)) }
    override method left() { gestorDeJugadores.moverA(izquierda.aplicarCantidad(2)) }
    override method right() { gestorDeJugadores.moverA(derecha.aplicarCantidad(2)) }

    override method r() { gestorNiveles.reiniciarNivel() }
    override method m() { menu.iniciar() }
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
