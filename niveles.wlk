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
        self.iniciarNivel()
    }

    method limpiar() {
        game.allVisuals().forEach({ visual => game.removeVisual(visual) })
    }
    
    method reiniciarNivel() {
        self.limpiar()
        jugador.reiniciarVidas()
        jugador.resetearPuntajeTemporal()
        self.iniciarNivel()
        gestorTeclado.juegoEnMarcha() // Rehabilitar controles 
    }
}

//*==========================| Niveles |==========================

class NivelBase {
    method mapaDeCuadricula() = [] /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
    
    var property siguienteNivel = null

    // Métodos de creación de objetos del nivel
    method crearPisos(positions) {
        positions.forEach({ pos =>
            const piso = new Piso(position = pos)
            piso.iniciar()
        })
    }

    method crearParedes(positions) {
        positions.forEach({ pos =>
            game.addVisual(new Pared(position = pos))
        })
    }

    method agregarMeta(pos) {
        const meta = new Meta(position = pos)
        self.crearPisos([pos])
        game.addVisual(meta)
    }

    method crearMonedas(positions) {
        positions.forEach({ pos =>
            const moneda = new Moneda(position = pos)
            self.crearPisos([pos])
            game.addVisual(moneda)
        })
    }
    
    method crearMonedaFalsa(positions) {
        positions.forEach({ pos =>
            const monedaFalsa = new MonedaFalsa(position = pos)
            self.crearPisos([pos])
            game.addVisual(monedaFalsa)
        })
    }

    method crearPinchos(positions) {
        positions.forEach({ pos =>
            const pincho = new Pincho(position = pos)
            self.crearPisos([pos])
            game.addVisual(pincho)
        })
    }

    method crearPinchosMoviles(positions) {
        positions.forEach({ pos =>
            const pinchoMov = new PinchoMovil(position = pos)
            self.crearPisos([pos])
            game.addVisual(pinchoMov)
            pinchoMov.moverPinchoMovil()
        })
    }

    method crearPinchosInvisibles(positions) {
        positions.forEach({ pos =>
            const pinchoInv = new PinchoInvisible(position = pos)
            self.crearPisos([pos])
            game.addVisual(pinchoInv)
            pinchoInv.hacerVisible()
        })
    }

    method crearPinchosInvisiblesInstantaneos(positions) {
        positions.forEach({ pos =>
            const pinchoInvInst = new PinchoInvisibleInstantaneo(position = pos)
            self.crearPisos([pos])
            game.addVisual(pinchoInvInst)
        })
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
        const elementos = ["_", "j", "p", "m", "c", "n", "s", "f", "i", "d"]
        
        elementos.forEach({ tipo =>
            var y = game.height() - 1  // Empezamos desde la altura máxima
            var x = 0                  // Empezamos desde el borde izquierdo
            self.mapaDeCuadricula().forEach({ fila =>
                x = 0
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
        
        if (celda == "_") {
            self.crearPisos([pos])
        } else if (celda == "j") {
            self.crearPisos([pos])
            jugador.position(pos)
        } else if (celda == "p") {
            self.crearParedes([pos])
        } else if (celda == "m") {
            self.agregarMeta(pos)
        } else if (celda == "c") {
            self.crearMonedas([pos])
        } else if(celda == "n") {
            self.crearMonedaFalsa([pos])
        } else if (celda == "s") {
            self.crearPinchos([pos])
        } else if(celda == "f") {
            self.crearPinchosInvisiblesInstantaneos([pos])
        } else if(celda == "i") {
            self.crearPinchosInvisibles([pos])
        } else if(celda == "d") {
            self.crearPinchosMoviles([pos])
        }
        // Si es V (vacío) o cualquier otro caracter, no hacemos nada
    }
}

//*==========================| Niveles Instanciados |==========================

object nivel1 inherits NivelBase(siguienteNivel = nivel2) {
    override method mapaDeCuadricula() = [
        /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
        // 24 columnas x 12 filas
                // 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
        /*11*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /*10*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* 9*/ ["v","v","v","v","v","v","_","p","p","p","p","p","p","p","p","p","_","_","v","v","v","v","v","v"],
        /* 8*/ ["v","v","v","v","v","v","_","_","_","_","p","c","c","c","c","p","_","_","v","v","v","v","v","v"],
        /* 7*/ ["v","v","v","v","v","v","j","p","_","_","_","_","p","p","c","p","_","_","v","v","v","v","v","v"],
        /* 6*/ ["v","v","v","v","v","v","_","p","p","_","p","_","_","p","_","i","m","_","v","v","v","v","v","v"],
        /* 5*/ ["v","v","v","v","v","v","_","d","_","_","p","p","p","p","p","_","f","_","v","v","v","v","v","v"],
        /* 4*/ ["v","v","v","v","v","v","_","p","p","_","p","_","_","_","_","_","_","_","v","v","v","v","v","v"],
        /* 3*/ ["v","v","v","v","v","v","_","p","_","_","_","_","p","p","p","p","_","_","v","v","v","v","v","v"],
        /* 2*/ ["v","v","v","v","v","v","_","p","p","p","_","p","p","_","p","_","_","_","v","v","v","v","v","v"],
        /* 1*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* 0*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"]
    ]
}

object nivel2 inherits NivelBase(siguienteNivel = nivel3) {
    override method mapaDeCuadricula() = [
        /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
        // 24 columnas x 12 filas
                    // x = 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
        /* y = 11*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* y = 10*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* y = 9*/  ["v","v","v","v","v","v","p","p","p","_","_","m","_","_","p","p","_","_","v","v","v","v","v","v"],
        /* y = 8*/  ["v","v","v","v","v","v","_","p","_","_","p","p","p","_","_","_","_","_","v","v","v","v","v","v"],
        /* y = 7*/  ["v","v","v","v","v","v","p","_","_","p","_","_","_","p","_","_","_","_","v","v","v","v","v","v"],
        /* y = 6*/  ["v","v","v","v","v","v","p","_","p","_","_","p","_","p","p","i","_","_","v","v","v","v","v","v"],
        /* y = 5*/  ["v","v","v","v","v","v","_","_","_","_","p","_","_","_","p","_","n","_","v","v","v","v","v","v"],
        /* y = 4*/  ["v","v","v","v","v","v","_","p","_","p","p","_","p","_","_","_","c","_","v","v","v","v","v","v"],
        /* y = 3*/  ["v","v","v","v","v","v","_","_","_","_","p","_","_","_","p","p","_","_","v","v","v","v","v","v"],
        /* y = 2*/  ["v","v","v","v","v","v","_","_","_","_","_","j","_","_","_","_","_","_","v","v","v","v","v","v"],
        /* y = 1*/  ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* y = 0*/  ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"]
    ]
    
    /*
    override method iniciar() {
        super()
        
        // Configuraciones específicas del nivel 2
        game.onTick(2000, "movimiento", { caja.movete() })
    }
    */
}

object nivel3 inherits NivelBase(siguienteNivel = endOfTheGame) {
    override method mapaDeCuadricula() = [
        /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
        // 24 columnas x 12 filas
                    // x = 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
        /* y = 11*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* y = 10*/ ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* y = 9*/  ["v","v","v","v","v","v","p","p","p","_","_","m","_","_","p","p","_","_","v","v","v","v","v","v"],
        /* y = 8*/  ["v","v","v","v","v","v","_","p","_","_","p","p","p","_","_","_","_","_","v","v","v","v","v","v"],
        /* y = 7*/  ["v","v","v","v","v","v","p","_","_","p","_","_","_","p","_","_","_","_","v","v","v","v","v","v"],
        /* y = 6*/  ["v","v","v","v","v","v","p","_","p","_","_","p","_","p","p","i","_","_","v","v","v","v","v","v"],
        /* y = 5*/  ["v","v","v","v","v","v","_","_","_","_","p","_","_","_","p","_","_","_","v","v","v","v","v","v"],
        /* y = 4*/  ["v","v","v","v","v","v","_","p","_","p","p","_","p","_","_","_","_","_","v","v","v","v","v","v"],
        /* y = 3*/  ["v","v","v","v","v","v","_","_","_","_","p","_","_","_","p","p","_","_","v","v","v","v","v","v"],
        /* y = 2*/  ["v","v","v","v","v","v","_","_","_","_","_","j","_","_","_","_","_","_","v","v","v","v","v","v"],
        /* y = 1*/  ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"],
        /* y = 0*/  ["v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v","v"]
    ]
    
    override method iniciar() {
        // Configurar el teclado invertido para este nivel
        gestorTeclado.cambiarConfiguracion(configTecladoInvertido)
        super()
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

