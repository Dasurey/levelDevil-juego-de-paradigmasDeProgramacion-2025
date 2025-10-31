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

        configTeclado.iniciar()
        gestorNiveles.iniciarNivel()
    }
}

// Fijase si esta bien esto
object gestorDeFinalizacion {
    method iniciar() {
        configTeclado.juegoBloqueado()
        // Detener todos los PinchosMovil
        game.allVisuals()
            .filter({ visual => visual.toString().contains("PinchoMovil") })
            .forEach({ pinchoMovil => pinchoMovil.detenerMovimiento() })
    }
}

object gestorDeJugadores {
    var property jugadorActual = jugadorLevelDevil

    method moverA(direccion) {
        self.jugadorActual().moverA(direccion)
    }

    method position() = self.jugadorActual().position()

    method position(pos) {
        jugadorActual.position(pos)
    }

    method resetearPuntajeTemporal() {
        jugadorActual.resetearPuntajeTemporal()
    }
}

class Personaje {
    var property position
    var vidasActuales
    var vidasDefault
    var puntaje = 0
    var puntajeTemporalGanado = 0
    var puntajeTemporalPerdido = 0
    var property estado
    var cantidadDeMovimientos = 0

    method cantidadDeCansancio() = (cantidadDeMovimientos / 2) * estado.cansancio()

    method potencialDefensivo() = 10 * vidasActuales + estado.potencialDefensivoExtra()

    method reiniciarVidas() {
        vidasActuales = vidasDefault
    }
    
    const imagenes
    var property image = imagenes.first()

    method esPisable() = true

    method esMeta() = false

    method mover(direccion) {
        const nuevaPosition = direccion.calcularNuevaPosition(self.position())
        if (configTeclado.controlesHabilitados()) {
            self.position(nuevaPosition)
        }
    }

    method moverA(direccion) {
        if(self.cantidadDeCansancio() > 0) {
            cantidadDeMovimientos += 1
            game.schedule(self.cantidadDeCansancio(), { 
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
    method cansancio() = 10

    method potencialDefensivoExtra() = 200
}

object sinEnergias {
    method cansancio() = 8

    method potencialDefensivoExtra() = 20
}

object explorador {
    method cansancio() = 0

    method potencialDefensivoExtra() = 10
}

object escurridizo {
    method cansancio() = 0

    method potencialDefensivoExtra() = 30
}

object jugadorLevelDevil inherits Personaje(position = game.at(0,0), estado = escurridizo, imagenes = ["JugadorLevelDevil_V1.png", "ExplosionAlMorir.gif"], vidasActuales = 1, vidasDefault = 1) {}

object zombie inherits Personaje(position = game.at(0,0), estado = muertoVivo, imagenes = ["Zombie_Derecha.png", "ExplosionAlMorir.gif"], vidasActuales = 5, vidasDefault = 5) {}

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
            configTeclado.juegoEnMarcha()
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

    var visible = false // comienza invisible

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
            const positionX = (gestorDeJugadores.position().x() - self.position().x()).abs()
            const positionY = (gestorDeJugadores.position().y() - self.position().y()).abs()

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
