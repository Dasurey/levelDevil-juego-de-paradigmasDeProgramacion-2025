import niveles.*
import tecladoYMenu.*

//        Configura el juego, arranca todo, inicializa teclado, etc.
object juegoLevelDevil {
    method iniciar() {
        game.title("Level Devil")
        game.height(12)
        game.width(24)
        game.boardGround("Fondo.png")

        // Configurar las colisiones con los pinchos
        game.onCollideDo(gestorDeJugadores.jugadorActual(), { elemento => elemento.interactuarConPersonaje(gestorDeJugadores.jugadorActual()) })

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

object gestorDeJugadores {
    var property jugadorActual = jugadorLevelDevil
}


class Personaje {
    var property position
    var vidasActuales = estado.vidasActuales()
    const vidasDefault = estado.vidasDefault()
    var puntaje = 0
    var puntajeTemporalGanado = 0
    var puntajeTemporalPerdido = 0
    var property estado

    method potencialDefensivo() = 10 * vidasActuales + estado.potencialDefensivoExtra()

    method reiniciarVidas() {
        vidasActuales = vidasDefault
    }
    
    const imagenes
    var property image = imagenes.first()
    method esPisable() = true

    method esMeta() = false

    method mover(direccion) {
        const nuevaPosition = direccion.calcularNuevaPosition(gestorDeJugadores.jugadorActual().position())
        if (gestorTeclado.configActual.controlesHabilitados()) {
            gestorDeJugadores.jugadorActual().position(nuevaPosition)
        }
    }

    method moverA(direccion) {
        const cantidadDeCansancio = estado.cansancio()
        if(cantidadDeCansancio > 0) {
            game.schedule(cantidadDeCansancio, { 
                self.mover(direccion)
            })
        } else {
            self.mover(direccion)
        }
    }

    method morir() {
        vidasActuales -= 1
        if (vidasActuales <= 0) {
            gestorDeFinalizacion.iniciar()
            game.say(self, "¡Has perdido todas tus vidas! Juego terminado.")
            self.sumaDePuntaje(self.puntajeTemporalPerdido())
            image = imagenes.last()
            game.schedule(2000, {
                gestorNiveles.reiniciarNivel() // delegás en el gestor lo que pasa al morir
                self.reiniciarVidas()
                image = imagenes.first()
            })
        } else {
            game.say(self, "¡Has perdido una vida! Vidas restantes: " + vidasActuales)
        }
    }

    method puntaje() = puntaje

    method sumaDePuntaje(puntos) {
        puntaje += puntos
    }

    method puntajeTemporalGanado() = puntajeTemporalGanado

    method sumaDePuntajeTemporalGanado(puntos) {
        puntajeTemporalGanado += puntos
    }

    method puntajeTemporalPerdido() = puntajeTemporalPerdido

    method restaDePuntajeTemporalPerdido(puntos) {
        puntajeTemporalPerdido -= puntos
    }

    method resetearPuntajeTemporal() {
        puntajeTemporalGanado = 0
        puntajeTemporalPerdido = 0
    }

    method puntajeCompleto() = self.puntaje() + self.puntajeTemporalGanado() + self.puntajeTemporalPerdido()
}

object muertoVivo {
    method cansancio() = 1000

    var property vidasActuales = 5
    const vidasDefault = 5

    method vidasDefault() = vidasDefault

    method potencialDefensivoExtra() = 5
}

object sinEnergias {
    method cansancio() = 800

    var property vidasActuales = 2
    const vidasDefault = 2

    method vidasDefault() = vidasDefault

    method potencialDefensivoExtra() = 20
}

object explorador {
    method cansancio() = 0

    var property vidasActuales = 3
    const vidasDefault = 3

    method vidasDefault() = vidasDefault

    method potencialDefensivoExtra() = 10
}

object escurridizo {
    method cansancio() = 0

    var property vidasActuales = 1
    const vidasDefault = 1

    method vidasDefault() = vidasDefault

    method potencialDefensivoExtra() = 30
}

object jugadorLevelDevil inherits Personaje(position = game.at(0,0), estado = escurridizo, imagenes = ["JugadorLevelDevil_V1.png", "ExplosionAlMorir.gif"]) {}

class Piso {
    var property position

    const imagenes = ["Piso1.png", "Piso2.png", "Piso3.png"]
    var property image = ""

    method imagenAleatoria(){
        image = imagenes.anyOne()
    }

    method ponerImagen(){
        self.imagenAleatoria()
        game.addVisual(self)
    }

    method esPisable() = true

    method esMeta() = false

    method interactuarConPersonaje(pj){}
}

class Pared {
    const property position
    
    const imagenes = ["Muro1.png", "Muro2.png", "Muro3.png", "Muro4.png"]
    var property image = ""

    method imagenAleatoria(){
        image = imagenes.anyOne()
    }

    method ponerImagen(){
        self.imagenAleatoria()
        game.addVisual(self)
    }

    method esPisable() = false

    method esMeta() = false

    method interactuarConPersonaje(pj){
        throw new Exception(message = "El personaje no puede pasar a través de paredes.")
    }
}

class Meta {
    var property position

    var property image = "Meta_V2.png"

    method esPisable() = true

    method esMeta() = true

    method interactuarConPersonaje(pj) {
        gestorDeFinalizacion.iniciar()
        pj.sumaDePuntaje(pj.puntajeTemporalPerdido() + pj.puntajeTemporalGanado())
        pj.resetearPuntajeTemporal()
        game.say(pj, "¡Nivel completado! Puntaje: " + pj.puntaje())
            game.removeVisual(gestorDeJugadores.jugadorActual())
            image = "JugadorMeta.gif"
        game.schedule(3000, {
            gestorNiveles.siguienteNivel()
            // Rehabilitamos los controles después del cambio de nivel
            gestorTeclado.juegoEnMarcha()
            
        })
    }
}

class Moneda {
    var property position

    method image() = "Moneda_V2.png"

    method esPisable() = true

    method esMeta() = false

    method interactuarConPersonaje(pj) {
        pj.sumaDePuntajeTemporalGanado(100)
        game.say(pj, "¡Moneda recogida! Puntaje: " + pj.puntajeCompleto())
        game.removeVisual(self)
    }
}

class ObjetoMorible {
    var property position

    method ataque()
    
    method image()

    method esPisable() = true

    method esMeta() = false

    method interactuarConPersonaje(pj) {
        if(pj.potencialDefensivo() < self.ataque()) {
            pj.restaDePuntajeTemporalPerdido(50)
            pj.morir()
        }
    }
}

class MonedaFalsa inherits ObjetoMorible {
    override method ataque() = 500

    override method image() = "Moneda_V2.png"

    override method interactuarConPersonaje(pj) {
        game.removeVisual(self)
        if(pj.potencialDefensivo() < self.ataque()) {
            pj.restaDePuntajeTemporalPerdido(100)
            pj.morir()
        }
    }
}

class Pincho inherits ObjetoMorible {
    override method ataque() = 100
    
    override method image() = "PinchoSimple_V2.png"
}

class PinchoInvisibleInstantaneo inherits ObjetoMorible {
    override method ataque() = 400

    var property visible = false // comienza invisible

    // La imagen depende de la propiedad 'visible'
    override method image() {
        if (visible) {
            return "PinchoSimple_V2.png"
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
    override method ataque() = 150

    // Genero un id por instancia para no pisar otros onTick
    const tickId = "mostrarPincho_" + self.identity()

    var property visible = false // comienza invisible

    // La imagen depende de la propiedad 'visible'
    override method image() {
        if (visible) {
            return "PinchoTriple_V2.png"
        } else {
            return null
        }
    }

    method hacerVisible() {
        game.onTick(100, tickId, {
            const positionX = (gestorDeJugadores.jugadorActual().position().x() - self.position().x()).abs()
            const positionY = (gestorDeJugadores.jugadorActual().position().y() - self.position().y()).abs()

            // Si el jugador está cerca, marcamos visible el pincho
            if (positionX <= 1 and positionY <= 1) {
                visible = true
            }
        })
    }
}

class PinchoMovil inherits ObjetoMorible {
    override method ataque() = 350

    const tickId = "moverPinchoMovil_" + self.identity()

    override method image() = "PinchoTriple_V2.png"

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