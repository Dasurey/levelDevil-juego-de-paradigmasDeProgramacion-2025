import niveles.*
import tecladoYMenu.*
import visualizadores.*

object juegoLevelDevil {
    const sonidoMenu = game.sound("Jugando.mp3")

    method iniciar() {
        game.title("Level Devil")
        game.height(12)
        game.width(24)
        game.boardGround("Fondo.png")

        sonidoMenu.shouldLoop(true)
        sonidoMenu.volume(0.1)
        sonidoMenu.play()

        // Activar Colisiones
        self.activarColisiones()

        configTeclado.iniciar()

        //Inicio el menu
        menu.iniciar()
    }

    method activarColisiones() {
        game.onCollideDo(jugadorLevelDevil, { elemento => elemento.interactuarConPersonaje(jugadorLevelDevil) })
        game.onCollideDo(zombie, { elemento => elemento.interactuarConPersonaje(zombie) })
        game.onCollideDo(miniMessi, { elemento => elemento.interactuarConPersonaje(miniMessi) })
        game.onCollideDo(satoruGojo, { elemento => elemento.interactuarConPersonaje(satoruGojo) })
    }

    method limpiar() {
        gestorNiveles.limpiar()
        gestorVisualizadores.limpiar()
        game.allVisuals().forEach({ visual => game.removeVisual(visual) })
    }

    method detenerMovimientos() {
        configTeclado.juegoBloqueado()
        // Detener todos los PinchosMovil buscando sus tick events
        game.allVisuals()
            .filter({ visual => visual.toString().contains("PinchoMovil") })
            .forEach({ pinchoMovil => pinchoMovil.detenerMovimiento() })
    }
}

object gestorDeJugadores {
    var jugadorActual = jugadorLevelDevil
    method jugadorActual() = jugadorActual

    method moverA(direccion) {
        self.jugadorActual().moverA(direccion)
    }

    method position() = self.jugadorActual().position()

    method vidasActuales() = self.jugadorActual().vidasActuales()

    method imagenesDeMeta() = self.jugadorActual().imagenesDeMeta()

    method position(pos) {
        jugadorActual.position(pos)
    }

    method puntaje() = jugadorActual.puntaje()

    method resetearPuntajeTemporal() {
        jugadorActual.resetearPuntajeTemporal()
    }

    method resetearPuntaje() {
        jugadorActual.resetearPuntaje()
    }

    method reiniciarVidas() {
        jugadorActual.reiniciarVidas()
    }

    method seleccionarPersonaje(jugador) {
        jugadorActual = jugador // Por ahora solo hay un personaje
    }
}

class Personaje {
    var property position

    var property vidasActuales
    const vidasPorDefecto

    var property puntaje = 0
    var puntajeTemporalGanado = 0
    var puntajeTemporalPerdido = 0

    var property rol
    
    var cantidadDeMovimientos = 0
    method cantidadDeMovimientos() = cantidadDeMovimientos

    method cantidadDeCansancio() = ((cantidadDeMovimientos * rol.cansancio()) / 10).truncate(0)

    method potencialDefensivo() = 10 * vidasActuales + rol.potencialDefensivoExtra()

    method reiniciarVidas() {
        vidasActuales = vidasPorDefecto
    }
    
    const imagenes
    var imagen = imagenes.first()
    method image() = imagen

    const imagenesDeMeta
    method imagenesDeMeta() = imagenesDeMeta

    method esPisable() = true

    method esMeta() = false

    method mover(direccion) {
        const nuevaPosition = direccion.calcularNuevaPosition(self.position())
        self.position(nuevaPosition)
    }

    method moverA(direccion) {
        if(rol.cansancio() > 0) {
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
        gestorVisualizadores.actualizarVidas(vidasActuales)
        if (vidasActuales <= 0) {
            juegoLevelDevil.detenerMovimientos()
            imagen = imagenes.last()
            game.schedule(2000, {
                self.sumaDePuntaje(self.puntajeTemporalPerdido())
                gestorNiveles.reiniciarNivel() // delegás en el gestor lo que pasa al morir
                self.reiniciarVidas()
                gestorVisualizadores.actualizarVidas(vidasActuales)
                imagen = imagenes.first()
            })
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

    method resetearPuntaje() {
        puntaje = 0
        self.resetearPuntajeTemporal()
    }

    method puntajeCompleto() = self.puntaje() + self.puntajeTemporalGanado() + self.puntajeTemporalPerdido()
}

object explorador {
    method cansancio() = 0

    method potencialDefensivoExtra() = 10
}

object muertoVivo {
    method cansancio() = 1

    method potencialDefensivoExtra() = 250
}

object gambetiador {
    method cansancio() = 0

    method potencialDefensivoExtra() = 200
}

object nahYoGanare {
    method cansancio() = 0

    method potencialDefensivoExtra() = 150
}

object jugadorLevelDevil inherits Personaje(position = game.at(0, 0), rol = explorador, imagenes = ["JugadorLevelDevil_V1.png", "ExplosionAlMorir.gif"], vidasActuales = 1, vidasPorDefecto = 1, imagenesDeMeta = ["MetaConJugadorLevelDevilParte1.png", "MetaConJugadorLevelDevilParte2.png", "MetaConJugadorLevelDevilParte3.png"]) {}

object zombie inherits Personaje(position = game.at(0, 0), rol = muertoVivo, imagenes = ["Zombie.png", "ExplosionAlMorir.gif"], vidasActuales = 5, vidasPorDefecto = 5, imagenesDeMeta = ["MetaConZombieParte1.png", "MetaConZombieParte2.png", "MetaConZombieParte3.png"]) {}

object miniMessi inherits Personaje(position = game.at(0, 0), rol = gambetiador, imagenes = ["MiniMessi.png", "ExplosionAlMorir.gif"], vidasActuales = 4, vidasPorDefecto = 4, imagenesDeMeta = ["MetaConMiniMessiParte1.png", "MetaConMiniMessiParte2.png", "MetaConMiniMessiParte3.png"]) {}

object satoruGojo inherits Personaje(position = game.at(0, 0), rol = nahYoGanare, imagenes = ["SatoruGojo_V2.png", "SatoruGojoMuerto_V2.png"], vidasActuales = 2, vidasPorDefecto = 2, imagenesDeMeta = ["MetaConSatoruGojoParte1_V2.png", "MetaConSatoruGojoParte2_V2.png", "MetaConSatoruGojoParte3_V2.png"]) {}

class Piso {
    var property position

    const imagenes = ["Piso1.png", "Piso2.png", "Piso3.png"]
    var imagen = ""
    method image() = imagen

    method imagenAleatoria(){
        imagen = imagenes.anyOne()
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
    var imagen = ""
    method image() = imagen

    method imagenAleatoria(){
        imagen = imagenes.anyOne()
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

    const imagenes = ["Meta_V2.png"] + gestorDeJugadores.imagenesDeMeta()

    var imagen = imagenes.first()

    method image() = imagen

    method esPisable() = true

    method esMeta() = true

    method interactuarConPersonaje(pj) {
        juegoLevelDevil.detenerMovimientos()
        pj.sumaDePuntaje(pj.puntajeTemporalPerdido() + pj.puntajeTemporalGanado())
        pj.resetearPuntajeTemporal()
        game.removeVisual(gestorDeJugadores.jugadorActual())
        const sonidoGanador = game.sound("Victoria.mp3")
        sonidoGanador.volume(1)
        sonidoGanador.play()
        imagen = imagenes.get(1)
        game.schedule(333, {
            imagen = imagenes.get(2)
            game.schedule(333, {
                imagen = imagenes.get(3)
                game.schedule(333, {
                    // Rehabilitamos los controles después del cambio de nivel
                    configTeclado.juegoEnMarcha()
                    gestorNiveles.siguienteNivel()
                })
            })
        })
    }
}

class Moneda {
    var property position

    method image() = "Moneda_V2.png"

    method esPisable() = true

    method esMeta() = false

    method interactuarConPersonaje(pj) {
        const sonidoMoneda = game.sound("Moneda.mp3")
        sonidoMoneda.volume(1)
        sonidoMoneda.play()
        pj.sumaDePuntajeTemporalGanado(100)
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
            const sonidoMuerte = game.sound("Muerte.mp3")
            sonidoMuerte.volume(1)
            sonidoMuerte.play()
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
            const sonidoMuerte = game.sound("Muerte.mp3")
            sonidoMuerte.volume(1)
            sonidoMuerte.play()
            pj.restaDePuntajeTemporalPerdido(100)
            pj.morir()
        }
    }
}

class Pincho inherits ObjetoMorible {
    override method ataque() = 180
    
    override method image() = "PinchoSimple_V1.png"
}

class PinchoInvisibleInstantaneo inherits ObjetoMorible {
    override method ataque() = 400

    var property visible = false // comienza invisible

    // La imagen depende de la propiedad 'visible'
    override method image() {
        if (visible) {
            return "PinchoSimple_V1.png"
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
            return "PinchoTriple_V1.png"
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
    override method ataque() = 250

    const tickId = "moverPinchoMovil_" + self.identity()

    override method image() = "PinchoTriple_V1.png"

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