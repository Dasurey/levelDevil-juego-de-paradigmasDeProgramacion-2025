import niveles.*
import teclado.*

//        Configura el juego, arranca todo, inicializa teclado, etc.
object juegoLevelDevil {
    method iniciar() {
        game.title("Level Devil")
        game.height(12)
        game.width(24)
        game.boardGround("fondo.jpg")

        // Configurar las colisiones con los pinchos
        game.onCollideDo(jugador, { elemento => elemento.interactuarConPersonaje(jugador) })

        gestorTeclado.iniciarConfiguracionDeTeclas()
        gestorNiveles.iniciarNivel()
    }
}

// Fijase si esta bien esto
object gestorDeFinalizacion {
    method iniciar() {
        gestorTeclado.juegoBloqueado()
        // Detener todos los PinchosMovil
        game.allVisuals()
            .filter({ visual => visual.toString().contains("PinchoMovil") })
            .forEach({ pinchoMovil => pinchoMovil.detenerMovimiento() })
    }
}

//         Jugador principal
object jugador {
    var property position = game.at(0, 6)
    var vidas = 2
    var puntaje = 0
    var puntajeTemporal = 0

    method reiniciarVidas() {
        vidas = 2
    }
    
    method image() = "zombieDerecha.png"
    
    method esPisable() = true

    method esMeta() = false

    method morir() {
        vidas -= 1
        if (vidas <= 0) {
            gestorDeFinalizacion.iniciar()
            self.resetearPuntajeTemporal()
            game.say(self, "¡Has perdido todas tus vidas! Juego terminado.")
            game.schedule(2000, {
                gestorNiveles.reiniciarNivel() // delegás en el gestor lo que pasa al morir
                gestorTeclado.juegoEnMarcha() // Rehabilitar controles
            })
        } else {
            game.say(self, "¡Has perdido una vida! Vidas restantes: " + vidas)
        }
    }

    method puntaje() = puntaje
    
    method modificarPuntajePorSumaResta(puntos) {
        puntaje += puntos
    }

    method puntajeTemporal() = puntajeTemporal

    method sumaDePuntajeTemporal(puntos) {
        puntajeTemporal += puntos
    }
    
    method resetearPuntajeTemporal(){
        puntajeTemporal = 0
    }
}

class Piso {
    var property position

    method image() = "Piso2.png"

    method esPisable() = true

    method esMeta() = false

    method interactuarConPersonaje(pj){}
}

class Pared {
    const property position
    
    method image() = "Muro1.png"

    //Colision
    method esPisable() = false

    method esMeta() = false

    method interactuarConPersonaje(pj){}
}

class Meta {
    var property position

    method image() = "meta.jpg"

    method esPisable() = true

    method esMeta() = true

    method interactuarConPersonaje(pj) {
        gestorDeFinalizacion.iniciar()
        pj.modificarPuntajePorSumaResta(pj.puntajeTemporal())
        pj.resetearPuntajeTemporal()
        game.say(pj, "¡Nivel completado! Puntaje: " + pj.puntaje())
        
        // Cambiamos de nivel después de 2 segundos
        game.schedule(2000, {
            gestorNiveles.siguienteNivel()
            // Rehabilitamos los controles después del cambio de nivel
            gestorTeclado.juegoEnMarcha()
        })
    }
}

class Moneda {
    var property position

    method image() = "Moneda.png"

    method esPisable() = true

    method esMeta() = false

    method interactuarConPersonaje(pj) {
        pj.sumaDePuntajeTemporal(100)
        game.say(pj, "¡Moneda recogida! Puntaje: " + pj.puntaje())
        game.removeVisual(self)
    }
}

class ObjetoMorible {
    var property position
    
    method image()

    method esPisable() = true

    method esMeta() = false

    method interactuarConPersonaje(pj) {
        pj.modificarPuntajePorSumaResta((-50))
        pj.morir()
    }
}

class MonedaFalsa inherits ObjetoMorible {
    override method image() = "Moneda.png"

    override method interactuarConPersonaje(pj) {
        pj.modificarPuntajePorSumaResta((-50))
        game.removeVisual(self)
        super(pj)
    }
}

class Pincho inherits ObjetoMorible {    
    override method image() = "pinchoTriple.png"
}

class PinchoInvisibleInstantaneo inherits ObjetoMorible {
    var property visible = false // comienza invisible

    // La imagen depende de la propiedad 'visible'
    override method image() {
        if (visible) {
            return "pinchoTriple.png"
        } else {
            return null
        }
    }

    override method interactuarConPersonaje(pj) {
        visible = true
        super(pj)
    }
}

class PinchoInvisible inherits ObjetoMorible {
    var property visible = false // comienza invisible

    // La imagen depende de la propiedad 'visible'
    override method image() {
        if (visible) {
            return "pinchoTriple.png"
        } else {
            return null
        }
    }

    method hacerVisible() {
        // Genero un id por instancia para no pisar otros onTick
        const tickId = "mostrarPincho_" + self.position().x() + "_" + self.position().y()
        game.onTick(100, tickId, {
            const positionX = (jugador.position().x() - self.position().x()).abs()
            const positionY = (jugador.position().y() - self.position().y()).abs()

            // Si el jugador está cerca, marcamos visible el pincho
            if (positionX <= 1 and positionY <= 1) {
                visible = true
            }
        })
    }
}

class PinchoMovil inherits ObjetoMorible {
    const tickId = "moverPinchoMovil_" + self.identity()
    
    override method image() = "pinchoTriple.png"

    method moverseAleatoriamente() {
        const direcciones = [arriba, abajo, izquierda, derecha]
        const direccionAleatoria = direcciones.anyOne()
        const destino = direccionAleatoria.moverEnDireccion(position)
        const objetosEnDestino = game.getObjectsIn(destino)

        // Mover sólo si está dentro de límites, hay objetos, todos son pisables y NO hay una Meta
        if (!objetosEnDestino.any({obj => obj.esMeta()}) and direccionAleatoria.validarPosition(destino)) {
            position = destino
        }
    }

    method moverPinchoMovil() {
        // el pincho cada se mueve cada 0,3 seg
        game.onTick(300, tickId, {
            self.moverseAleatoriamente()
        })
    }
    
    method detenerMovimiento() {
        game.removeTickEvent(tickId)
    }
}

object caja {
    var property position = game.at(3, 0)

    method image() = "caja.png"

    method esPisable() = false

    method movete() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        
        // otra forma de generar números aleatorios
        // const x = (0.. game.width()-1).anyOne()
        // const y = (0.. game.height()-1).anyOne()
        position = game.at(x, y)
    }
}