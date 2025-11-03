import levelDevil.*
import tecladoYMenu.*
import visualizadores.*

// Nivel Base
class NivelBase {
    method mapaDeCuadricula() = [] /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
    
    var property siguienteNivel = null
    
    method numeroDeNivel() // Cada nivel debe implementar este método

    method iniciar() {
        gestorDeJugadores.resetearPuntajeTemporal()
        juegoLevelDevil.limpiar()

        new VisualSoloLectura(image="BotonMenu.png",position = game.at(22,11)).ponerImagen()
        new VisualSoloLectura(image="BotonReiniciar.png",position = game.at(0,0)).ponerImagen()

        // Dibujar el nivel usando el mapaDeCuadricula
        self.dibujarNivel()
        
        self.dibujarJugador()

        // Habilitar controles
        configTeclado.juegoEnMarcha()
        
        // Actualizar visualizador de niveles y vidas
        gestorVisualizadores.iniciar()
    }

    // Método para dibujar el nivel basado en el mapaDeCuadricula
    method dibujarNivel() {
        const elementos = [_, j, p, m, d, f, s, n, i, h, a]
        
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
        meta.ponerImagen()
    }
}

// Moneda
object d {
    method agregarAlNivel(x, y) {
        const moneda = new Moneda(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        moneda.ponerImagen()
    }
}

// Moneda Falsa
object f {
    method agregarAlNivel(x, y) {
        const monedaFalsa = new MonedaFalsa(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        monedaFalsa.ponerImagen()
    }
}

// Pincho
object s {
    method agregarAlNivel(x, y) {
        const pincho = new Pincho(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        pincho.ponerImagen()
    }
}

// Pincho Invisible
object i {
    method agregarAlNivel(x, y) {
        const pinchoInv = new PinchoInvisible(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        pinchoInv.ponerImagen()
        pinchoInv.hacerVisible()
    }
}

// Pincho Invisible Instantaneo
object n {
    method agregarAlNivel(x, y) {
        const pinchoInvInst = new PinchoInvisibleInstantaneo(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        pinchoInvInst.ponerImagen()
    }
}

// Pincho Movil
object h {
    method agregarAlNivel(x, y) {
        const pinchoMov = new PinchoMovil(position = game.at(x, y))
        _.agregarAlNivel(x, y)
        pinchoMov.ponerImagen()
        pinchoMov.moverPinchoMovil()
    }
}

// Jugador
object j {
    method agregarAlNivel(x, y) {
        const jugador = gestorDeJugadores.jugadorActual()
        jugador.position(game.at(x, y))
        _.agregarAlNivel(x, y)
    }
}

object a {
    method agregarAlNivel(x, y) {
        const flechas = new VisualSoloLectura(image="Flechas.png", position = game.at(x, y))
        flechas.ponerImagen()
    }
}

// Niveles específicos
object nivel1 inherits NivelBase(siguienteNivel = nivel2) {
    override method numeroDeNivel() = 1
    
    override method mapaDeCuadricula() = [
        /* Nivel 1 - El engaño (fácil en apariencia) */
        /*11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /*10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 9*/ [v,v,v,v,v,v,s,p,p,p,p,p,p,p,p,p,_,_,v,v,v,v,v,v],
        /* 8*/ [v,v,v,v,v,v,_,_,_,_,p,d,d,d,d,p,_,_,v,v,v,v,v,v],
        /* 7*/ [v,v,v,v,v,v,j,p,_,_,_,_,p,p,d,p,s,_,v,v,v,v,v,v],
        /* 6*/ [v,v,v,v,v,v,_,p,p,_,p,_,_,p,_,i,m,_,v,v,v,v,v,v],
        /* 5*/ [v,v,v,v,v,v,_,_,_,_,p,p,p,p,p,_,i,_,v,v,v,v,v,v],
        /* 4*/ [v,v,v,v,v,v,_,p,p,_,p,_,_,_,_,_,_,_,v,v,v,v,v,v],
        /* 3*/ [v,v,v,v,v,v,s,p,_,_,_,_,p,s,p,p,_,_,v,v,v,v,v,v],
        /* 2*/ [v,v,v,v,v,v,_,p,p,p,s,p,p,p,p,_,_,_,v,v,v,v,v,v],
        /* 1*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 0*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,a,v,v,v,v]
    ]
}

object nivel2 inherits NivelBase(siguienteNivel = nivel2) {
    override method numeroDeNivel() = 2
    
    override method mapaDeCuadricula() = [
        /* Recomendable no usar la fila y = 0 o 1 o 10 o 11 ni la x = 0 o 1 o 22 o 23 */
        // 24 columnas x 12 filas
                    // x = 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
        /* y = 11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 9*/  [v,v,v,v,v,v,p,p,p,_,_,m,n,_,p,p,_,_,v,v,v,v,v,v],
        /* y = 8*/  [v,v,v,v,v,v,_,p,_,_,p,p,p,_,_,_,h,_,v,v,v,v,v,v],
        /* y = 7*/  [v,v,v,v,v,v,p,_,_,p,_,_,_,p,_,_,_,_,v,v,v,v,v,v],
        /* y = 6*/  [v,v,v,v,v,v,p,_,p,_,h,p,_,p,p,i,_,_,v,v,v,v,v,v],
        /* y = 5*/  [v,v,v,v,v,v,_,_,_,_,p,_,_,_,p,_,f,_,v,v,v,v,v,v],
        /* y = 4*/  [v,v,v,v,v,v,_,p,_,p,p,_,p,_,_,_,d,_,v,v,v,v,v,v],
        /* y = 3*/  [v,v,v,v,v,v,_,_,_,_,p,_,_,_,p,p,_,_,v,v,v,v,v,v],
        /* y = 2*/  [v,v,v,v,v,v,_,_,_,_,_,j,_,_,_,_,_,_,v,v,v,v,v,v],
        /* y = 1*/  [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* y = 0*/  [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]

    override method iniciar() {
        super()
        configTeclado.cambiarTecladoA(tecladoInvertido)
    }
}

object nivel3 inherits NivelBase(siguienteNivel = nivel4) {
    override method numeroDeNivel() = 3
    
    override method mapaDeCuadricula() = [
        /*11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /*10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 9*/ [v,v,v,v,v,v,j,_,d,_,f,_,d,_,f,_,d,_,v,v,v,v,v,v],
        /* 8*/ [v,v,v,v,v,v,_,p,_,_,_,p,_,_,_,p,_,_,v,v,v,v,v,v],
        /* 7*/ [v,v,v,v,v,v,_,_,d,n,d,_,d,_,d,_,_,_,v,v,v,v,v,v],
        /* 6*/ [v,v,v,v,v,v,_,p,_,p,i,h,i,p,_,p,_,_,v,v,v,v,v,v],
        /* 5*/ [v,v,v,v,v,v,_,_,d,_,d,m,d,_,d,_,_,_,v,v,v,v,v,v],
        /* 4*/ [v,v,v,v,v,v,_,p,_,p,i,h,i,p,n,p,_,_,v,v,v,v,v,v],
        /* 3*/ [v,v,v,v,v,v,_,_,d,_,d,_,d,_,d,_,f,_,v,v,v,v,v,v],
        /* 2*/ [v,v,v,v,v,v,_,p,_,_,_,p,_,_,_,p,_,_,v,v,v,v,v,v],
        /* 1*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 0*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]

    override method iniciar() {
        super()
        configTeclado.cambiarTecladoA(tecladoDoble)
    }
}

object nivel4 inherits NivelBase(siguienteNivel = nivel5) {
    override method numeroDeNivel() = 4
    
    override method mapaDeCuadricula() = [
        /*11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /*10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 9*/ [v,v,v,v,v,v,_,j,d,f,n,m,f,d,d,_,_,_,v,v,v,v,v,v],
        /* 8*/ [v,v,v,v,v,v,p,_,_,_,i,_,i,_,_,p,_,_,v,v,v,v,v,v],
        /* 7*/ [v,v,v,v,v,v,_,_,d,_,d,_,d,_,d,_,_,_,v,v,v,v,v,v],
        /* 6*/ [v,v,v,v,v,v,p,_,_,p,i,f,i,p,_,p,_,_,v,v,v,v,v,v],
        /* 5*/ [v,v,v,v,v,v,_,_,d,_,d,d,d,_,d,_,_,_,v,v,v,v,v,v],
        /* 4*/ [v,v,v,v,v,v,p,_,_,p,i,f,i,p,_,p,_,_,v,v,v,v,v,v],
        /* 3*/ [v,v,v,v,v,v,_,_,d,_,d,_,d,_,d,_,n,_,v,v,v,v,v,v],
        /* 2*/ [v,v,v,v,v,v,p,_,_,_,i,_,i,_,_,p,d,_,v,v,v,v,v,v],
        /* 1*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 0*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]
}

object nivel5 inherits NivelBase(siguienteNivel = nivel6) {
    override method numeroDeNivel() = 5
    
    override method mapaDeCuadricula() = [
        /*11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /*10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 9*/ [v,v,v,v,v,v,j,_,d,d,f,_,d,d,d,f,d,_,v,v,v,v,v,v],
        /* 8*/ [v,v,v,v,v,v,_,_,s,_,_,_,_,_,s,_,_,_,v,v,v,v,v,v],
        /* 7*/ [v,v,v,v,v,v,_,p,_,_,d,d,d,_,_,p,_,_,v,v,v,v,v,v],
        /* 6*/ [v,v,v,v,v,v,_,_,s,_,f,f,f,_,s,_,_,_,v,v,v,v,v,v],
        /* 5*/ [v,v,v,v,v,v,_,p,_,_,d,i,d,_,_,p,_,_,v,v,v,v,v,v],
        /* 4*/ [v,v,v,v,v,v,_,_,s,_,f,f,f,_,s,_,_,_,v,v,v,v,v,v],
        /* 3*/ [v,v,v,v,v,v,_,p,_,_,d,d,d,_,_,p,_,_,v,v,v,v,v,v],
        /* 2*/ [v,v,v,v,v,v,_,_,s,_,_,_,_,_,s,m,_,_,v,v,v,v,v,v],
        /* 1*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 0*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]

    override method iniciar() {
        super()
        configTeclado.cambiarTecladoA(tecladoInvertido)
    }
}

object nivel6 inherits NivelBase(siguienteNivel = nivel7) {
    override method numeroDeNivel() = 6
    
    override method mapaDeCuadricula() = [
        /*11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /*10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 9*/ [v,v,v,v,v,v,j,_,d,f,d,_,d,f,d,_,d,_,v,v,v,v,v,v],
        /* 8*/ [v,v,v,v,v,v,_,s,_,h,_,_,_,h,_,s,_,_,v,v,v,v,v,v],
        /* 7*/ [v,v,v,v,v,v,_,_,d,_,d,d,d,_,d,_,_,_,v,v,v,v,v,v],
        /* 6*/ [v,v,v,v,v,v,_,s,_,i,f,f,f,n,_,s,_,_,v,v,v,v,v,v],
        /* 5*/ [v,v,v,v,v,v,_,_,d,_,d,d,d,_,d,_,_,_,v,v,v,v,v,v],
        /* 4*/ [v,v,v,v,v,v,_,s,_,i,f,f,f,n,_,s,_,_,v,v,v,v,v,v],
        /* 3*/ [v,v,v,v,v,v,_,_,d,_,d,d,d,_,d,_,_,_,v,v,v,v,v,v],
        /* 2*/ [v,v,v,v,v,v,_,s,_,h,_,m,_,h,_,s,_,_,v,v,v,v,v,v],
        /* 1*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 0*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]

    override method iniciar() {
        super()
        configTeclado.cambiarTecladoA(tecladoDoble)
    }
}

object nivel7 inherits NivelBase(siguienteNivel = creditosFinales) {
    override method numeroDeNivel() = 7
    
    override method mapaDeCuadricula() = [
        /*11*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /*10*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 9*/ [v,v,v,v,v,v,j,d,d,d,d,f,d,d,d,d,d,_,v,v,v,v,v,v],
        /* 8*/ [v,v,v,v,v,v,_,p,_,p,i,_,i,p,_,p,_,_,v,v,v,v,v,v],
        /* 7*/ [v,v,v,v,v,v,_,_,f,_,d,h,d,_,_,_,_,_,v,v,v,v,v,v],
        /* 6*/ [v,v,v,v,v,v,_,p,_,p,i,d,f,p,_,p,_,_,v,v,v,v,v,v],
        /* 5*/ [v,v,v,v,v,v,_,_,f,_,d,f,d,_,f,_,_,_,v,v,v,v,v,v],
        /* 4*/ [v,v,v,v,v,v,_,p,h,p,_,_,d,p,_,p,_,_,v,v,v,v,v,v],
        /* 3*/ [v,v,v,v,v,v,_,_,f,_,d,n,d,_,f,_,_,_,v,v,v,v,v,v],
        /* 2*/ [v,v,v,v,v,v,_,p,_,p,n,_,_,p,_,p,_,m,v,v,v,v,v,v],
        /* 1*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
        /* 0*/ [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ]

    override method iniciar() {
        super()
        configTeclado.cambiarTecladoA(tecladoInvertido)
    }
}

object creditosFinales {
    method siguienteNivel() = null

    method iniciar() {
        // Limpiar todo, incluyendo visualizadores
        juegoLevelDevil.limpiar()
        juegoLevelDevil.detenerMovimientos()
        if(gestorDeJugadores.puntaje() > 4000) {
            new VisualSoloLectura(image="JuegoTerminadoGano.png", position = game.at(0, 0)).ponerImagen()
        } else {
            new VisualSoloLectura(image="JuegoTerminadoPerdio.png", position = game.at(0, 0)).ponerImagen()
        }
        game.schedule(5000, {
            juegoLevelDevil.limpiar()
            new VisualSoloLectura(image="CreditosFinales.png", position = game.at(0, 0)).ponerImagen()
            game.stop()
        })
    }
}