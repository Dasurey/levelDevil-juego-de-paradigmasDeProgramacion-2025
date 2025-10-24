import levelDevil.*
import teclado.*

//          Administra los niveles
object gestorNiveles {
    var property nivelActual = nivel1

    method iniciarNivel() {
        nivelActual.iniciar()
    }

    method siguienteNivel() {
        nivelActual = nivelActual.siguienteNivel()
        nivelActual.iniciar()
    }

    method limpiar() {
        game.allVisuals().forEach({ visual => game.removeVisual(visual) })
    }
    
    method reiniciarNivel() {
        self.limpiar()
        nivelActual.iniciar()
        configTeclado.juegoEnMarcha() // Rehabilitar controles 
    }
}

//*==========================| Niveles |==========================

class NivelBase {
    method mapaDeCuadricula() = []
    
    var property siguienteNivel = null

    // Métodos de creación de objetos del nivel
    method crearParedes(positions) {
        positions.forEach({ pos =>
            game.addVisual(new Pared(position = pos))
        })
    }

    method crearPisos(positions) {
        positions.forEach({ pos =>
            game.addVisual(new Piso(position = pos))
        })
    }

    method crearPinchos(positions) {
        positions.forEach({ pos =>
            game.addVisual(new Pincho(position = pos))
            game.addVisual(new Piso(position = pos))
        })
    }

    method crearPinchosMoviles(positions) {
        positions.forEach({ pos =>
            const pinchoMov = new PinchoMovil(position = pos)
            game.addVisual(new Piso(position = pos))
            game.addVisual(pinchoMov)
            pinchoMov.moverPinchoMovil()
        })
    }

    method crearPinchosInvisibles(positions) {
        positions.forEach({ pos =>
            const pinchoInv = new PinchoInvisible(position = pos)
            game.addVisual(new Piso(position = pos))
            game.addVisual(pinchoInv)
            pinchoInv.hacerVisible()
        })
    }

    method agregarMeta(pos) {
        const meta = new Meta(position = pos)
        game.addVisual(new Piso(position = pos))
        game.addVisual(meta)
    }

    method iniciar() {
        // Limpiar pantalla
        gestorNiveles.limpiar()
        
        // Dibujar el nivel usando el mapaDeCuadricula
        self.dibujarNivel()
        
        // Agregar jugador
        game.addVisual(jugador)
    }

    // Método para dibujar el nivel basado en el mapaDeCuadricula
    method dibujarNivel() {
        const elementos = ["_", "p", "m", "i", "d", "j"]
        
        elementos.forEach({ tipo =>
            var y = 10
            var x = 2
            self.mapaDeCuadricula().forEach({ fila =>
                x = 2
                fila.forEach({ celda =>
                    if(celda == tipo) {
                        self.procesarCelda(celda, x, y)
                    }
                    x += 1
                })
                y -= 1
            })
        })
    }
    
    method procesarCelda(celda, x, y) {
        const pos = game.at(x, y)
        
        if (celda == "p") {
            self.crearParedes([pos])
        } else if (celda == "_") {
            self.crearPisos([pos])
        } else if (celda == "s") {
            self.crearPinchos([pos])
        } else if(celda == "i") {
            self.crearPinchosInvisibles([pos])
        } else if(celda == "d") {
            self.crearPinchosMoviles([pos])
        } else if (celda == "m") {
            self.agregarMeta(pos)
        } else if (celda == "j") {
            jugador.position(pos)
            game.addVisual(new Piso(position = pos))
        }
        // Si es V (vacío) o cualquier otro caracter, no hacemos nada
    }
}

//*==========================| Niveles Instanciados |==========================

object nivel1 inherits NivelBase(siguienteNivel = nivel2) {
    override method mapaDeCuadricula() = [
        ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        ["v","v","v","v","p","p","p","p","p","p","p","p","p","p","p","v","v","v","v","v"],
        ["v","v","v","v","p","_","_","_","_","_","_","_","_","_","p","v","v","v","v","v"],
        ["v","v","v","v","p","_","_","_","_","p","_","_","_","_","p","v","v","v","v","v"],
        ["v","v","v","v","p","_","j","_","_","p","_","_","_","_","p","v","v","v","v","v"],
        ["v","v","v","v","p","_","_","_","_","_","_","i","m","_","p","v","v","v","v","v"],
        ["v","v","v","v","p","_","_","_","_","_","_","d","_","_","p","v","v","v","v","v"],
        ["v","v","v","v","p","_","_","_","_","_","_","_","_","_","p","v","v","v","v","v"],
        ["v","v","v","v","p","p","p","p","p","p","p","p","p","p","p","v","v","v","v","v"],
        ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"]
    ]
}

object nivel2 inherits NivelBase(siguienteNivel = endOfTheGame) {
    override method mapaDeCuadricula() = [
        ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        ["v","v","v","v","p","p","p","p","p","p","p","p","p","p","p","v","v","v","v","v"],
        ["v","v","v","v","p","v","v","v","v","p","v","v","v","v","p","v","v","v","v","v"],
        ["v","v","v","v","p","v","j","v","v","p","v","v","v","v","p","v","v","v","v","v"],
        ["v","v","v","v","p","v","v","v","v","v","v","v","m","v","p","v","v","v","v","v"],
        ["v","v","v","v","p","v","v","v","v","v","v","v","v","v","p","v","v","v","v","v"],
        ["v","v","v","v","p","v","v","v","v","v","v","v","v","v","p","v","v","v","v","v"],
        ["v","v","v","v","p","p","p","p","p","p","p","p","p","p","p","v","v","v","v","v"],
        ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"]
    ]
    
    override method iniciar() {
        super()
        
        // Configuraciones específicas del nivel 2
        game.onTick(2000, "movimiento", { caja.movete() })
    }
}

object endOfTheGame inherits NivelBase(siguienteNivel = null) {
    override method mapaDeCuadricula() = []  // Nivel final no necesita mapa
    
    override method iniciar() {
        gestorNiveles.limpiar()
        game.say(jugador, "¡Juego completado!")
        game.schedule(3000, {
            game.stop()
        })
    }
}

