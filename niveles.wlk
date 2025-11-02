import levelDevil.*
import tecladoYMenu.*
import visualizadores.*

//          Administra los niveles
object gestorNiveles {
    var property nivelActual = nivel1
    
    method cantidadNivelesDesde(nivel) {
        if (nivel.siguienteNivel() == null) {
            return 0
        }
        return 1 + self.cantidadNivelesDesde(nivel.siguienteNivel())
    }
    
    method cantidadNiveles() = self.cantidadNivelesDesde(nivel1)
    
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
        gestorDeJugadores.resetearPuntajeTemporal()
        self.iniciarNivel()
        configTeclado.controlesEnMarcha() // Rehabilitar controles
    }
}

//*==========================| Niveles |==========================

class NivelBase {
    method mapaDeCuadricula() = [] /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
    
    var property siguienteNivel = null
    
    method numero() // Cada nivel debe implementar este método

    method iniciar() {
        // Limpiar pantalla
        juegoLevelDevil.limpiar()

        //Dibujo UI
        new VisualSoloLectura(image="Menu.png",position = game.at(22,11)).ponerImagen()
        
        // Dibujar el nivel usando el mapaDeCuadricula
        self.dibujarNivel()
        
        // Agregar jugador
        self.dibujarJugador()

        configTeclado.juegoEnMarcha() // Habilitar controles
        
        // Actualizar visualizador de niveles y vidas
        gestorVisualizadores.iniciar()
        
        gestorNiveles.nivelActual(self)
    }

    // Método para dibujar el nivel basado en el mapaDeCuadricula
    method dibujarNivel() {
        const elementos = [_, y, p, m, d, f, s, n, i, j]
        
        elementos.forEach({ tipo =>
            var y = game.height() - 1  // Empezamos desde la altura máxima
            var x = 0                  // Empezamos desde el borde izquierdo
            self.mapaDeCuadricula().forEach({ fila =>
                x = 0
                fila.forEach({ celda =>
                    if(celda == tipo) {
                        celda.agregarAlNivel(x, y)
                    }
                    x += 1
                })
                y -= 1
            })
        })
    }

    method dibujarJugador() {
        game.addVisual(gestorDeJugadores.jugadorActual())
    }
}

// Vacio
object v {
    method agregarAlNivel(_x, _y) {}
}

// Piso
object _ {
    method agregarAlNivel(x, y) {
        const piso = new Piso(position = game.at(x, y))
        piso.ponerImagen()
    }
}

// Pared
object p {
    method agregarAlNivel(x, y) {
        const pared = new Pared(position = game.at(x, y))
        pared.ponerImagen()
    }
}

// Meta
object m {
    method agregarAlNivel(x, y) {
        const meta = new Meta(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        game.addVisual(meta)
    }
}

// Moneda
object d {
    method agregarAlNivel(x, y) {
        const moneda = new Moneda(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        game.addVisual(moneda)
    }
}

// Moneda Falsa
object f {
    method agregarAlNivel(x, y) {
        const monedaFalsa = new MonedaFalsa(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        game.addVisual(monedaFalsa)
    }
}

// Pincho
object s {
    method agregarAlNivel(x, y) {
        const pincho = new Pincho(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        game.addVisual(pincho)
    }
}

// Pincho Invisible
object i {
    method agregarAlNivel(x, y) {
        const pinchoInv = new PinchoInvisible(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        game.addVisual(pinchoInv)
        pinchoInv.hacerVisible()
    }
}

// Pincho Invisible Instantaneo
object n {
    method agregarAlNivel(x, y) {
        const pinchoInvInst = new PinchoInvisibleInstantaneo(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        game.addVisual(pinchoInvInst)
    }
}

// Pincho Movil
object j {
    method agregarAlNivel(x, y) {
        const pinchoMov = new PinchoMovil(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        game.addVisual(pinchoMov)
        pinchoMov.moverPinchoMovil()
    }
}


object y {
    method agregarAlNivel(x, y) {
        const jugador = gestorDeJugadores.jugadorActual()
        jugador.position(game.at(x, y))
        _.agregarAlNivel(x, y)
    }
}

//*==========================| Niveles Instanciados |==========================

object nivel1 inherits NivelBase(siguienteNivel = nivel2) {
    override method numero() = 1
    
    override method mapaDeCuadricula() = [
        /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
        // 24 columnas x 12 filas
                // 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
        /*11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /*10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 9*/ [v,v,v,v,v,v,_,p,p,p,p,p,p,p,p,p,_,_,v,v,v,v,v,v],
        /* 8*/ [v,v,v,v,v,v,_,_,_,_,p,d,d,d,d,p,_,_,v,v,v,v,v,v],
        /* 7*/ [v,v,v,v,v,v,y,p,_,_,_,_,p,p,d,p,_,_,v,v,v,v,v,v],
        /* 6*/ [v,v,v,v,v,v,_,p,p,_,p,_,_,p,_,i,m,_,v,v,v,v,v,v],
        /* 5*/ [v,v,v,v,v,v,_,j,_,_,p,p,p,p,p,_,n,_,v,v,v,v,v,v],
        /* 4*/ [v,v,v,v,v,v,_,p,p,_,p,_,_,_,_,_,_,_,v,v,v,v,v,v],
        /* 3*/ [v,v,v,v,v,v,_,p,_,_,_,_,p,p,p,p,_,_,v,v,v,v,v,v],
        /* 2*/ [v,v,v,v,v,v,_,p,p,p,_,p,p,_,p,_,_,_,v,v,v,v,v,v],
        /* 1*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 0*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]
}

object nivel2 inherits NivelBase(siguienteNivel = nivel3) {
    override method numero() = 2
    
    override method mapaDeCuadricula() = [
        /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
        // 24 columnas x 12 filas
                    // x = 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
        /* y = 11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 9*/  [v,v,v,v,v,v,p,p,p,_,_,m,_,_,p,p,_,_,v,v,v,v,v,v],
        /* y = 8*/  [v,v,v,v,v,v,_,p,_,_,p,p,p,_,_,_,_,_,v,v,v,v,v,v],
        /* y = 7*/  [v,v,v,v,v,v,p,_,_,p,_,_,_,p,_,_,_,_,v,v,v,v,v,v],
        /* y = 6*/  [v,v,v,v,v,v,p,_,p,_,_,p,_,p,p,i,_,_,v,v,v,v,v,v],
        /* y = 5*/  [v,v,v,v,v,v,_,_,_,_,p,_,_,_,p,_,f,_,v,v,v,v,v,v],
        /* y = 4*/  [v,v,v,v,v,v,_,p,_,p,p,_,p,_,_,_,d,_,v,v,v,v,v,v],
        /* y = 3*/  [v,v,v,v,v,v,_,_,_,_,p,_,_,_,p,p,_,_,v,v,v,v,v,v],
        /* y = 2*/  [v,v,v,v,v,v,_,_,_,_,_,y,_,_,_,_,_,_,v,v,v,v,v,v],
        /* y = 1*/  [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 0*/  [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]
    
    /*
    override method iniciar() {
        super()
        
        // Configuraciones específicas del nivel 2
        game.onTick(2000, "movimiento", { caja.movete() })
    }
    */
}

object nivel3 inherits NivelBase(siguienteNivel = creditosFinales) {
    override method numero() = 3
    
    override method mapaDeCuadricula() = [
        /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
        // 24 columnas x 12 filas
                    // x = 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
        /* y = 11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 9*/  [v,v,v,v,v,v,p,p,p,_,_,m,_,_,p,p,_,_,v,v,v,v,v,v],
        /* y = 8*/  [v,v,v,v,v,v,_,p,_,_,p,p,p,_,_,_,_,_,v,v,v,v,v,v],
        /* y = 7*/  [v,v,v,v,v,v,p,_,_,p,_,_,_,p,_,_,_,_,v,v,v,v,v,v],
        /* y = 6*/  [v,v,v,v,v,v,p,_,p,_,_,p,_,p,p,i,_,_,v,v,v,v,v,v],
        /* y = 5*/  [v,v,v,v,v,v,_,_,_,_,p,_,_,_,p,_,_,_,v,v,v,v,v,v],
        /* y = 4*/  [v,v,v,v,v,v,_,p,_,p,p,_,p,_,_,_,_,_,v,v,v,v,v,v],
        /* y = 3*/  [v,v,v,v,v,v,_,_,_,_,p,_,_,_,p,p,_,_,v,v,v,v,v,v],
        /* y = 2*/  [v,v,v,v,v,v,_,_,_,_,_,y,_,_,_,_,_,_,v,v,v,v,v,v],
        /* y = 1*/  [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 0*/  [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]
    
    override method iniciar() {
        // Configurar el teclado invertido para este nivel
        configTeclado.cambiarTecladoA(tecladoInvertido)
        super()
    }
}

object creditosFinales {
    method siguienteNivel() = null

    method iniciar() {
        // Limpiar todo, incluyendo visualizadores
        juegoLevelDevil.limpiar()
        configTeclado.cambiarTecladoA(new TecladoBase())
        // new VisualSoloLectura(image="CreditosFinales.png", position = game.at(8, 1)).ponerImagen()
        game.stop()
    }
}
