import levels.*
import menuYTeclado.*

//*==========================| Manager Principal del Juego |==========================
object juegoFLDSMDFR {
    var property nivelActual = nivel1
    
    method iniciar() {
        // Set game properties
        game.title("FLDSMDFR")
        game.height(12)
        game.width(24)
        game.boardGround("fondo.jpg")
        
        // Inicializar teclado
        configTeclado.iniciar()
        
        // Cargar primer nivel
        nivelActual.iniciar()
        
        // Mostrar información de debug
        game.showAttributes(player)
    }
    
    method clear() {
        game.allVisuals().forEach { visual => game.removeVisual(visual) }
    }
    
    method siguienteNivel() {
        nivelActual = nivelActual.siguienteNivel()
        nivelActual.iniciar()
    }
}

//*==========================| Jugador Principal |==========================
// Jugador principal
object player {
    var property position = game.at(1, 1)
    var property vidas = 1
    var property puntaje = 0
    var nivelActual = 1
    const posicionInicial = game.at(1, 1)
    
    method image() = "player.jpg"
    
    method mover(direccion) {
        const nuevaPosicion = direccion.calcularNuevaPosicion(position)
        if (self.puedeMoverse(nuevaPosicion)) {
            position = nuevaPosicion
            self.collideWith()
        }
    }
    
    method puedeMoverse(nuevaPosicion) {
        return nuevaPosicion.x().between(0, game.width() - 1) and nuevaPosicion.y().between(0, game.height() - 1)
    }
    
    method collideWith() {
        game.getObjectsIn(position).forEach({objeto => objeto.interactuarConPersonaje(self)}) //? Utilizamos esto como onCollideDo ya que on colide se saltea colisiones y va mas lento
    }
    
    method perderVida() {
        self.desconectarControles()
        game.say(self, "¡Moriste!")
        game.schedule(1000, {
            self.respawnear()
        })
    }
    
    method respawnear() {
        position = posicionInicial
        game.say(self, "¡De vuelta al inicio!")
        self.reconectarControles()
    }
    
    method desconectarControles() {
        configTeclado.gameBlocked()
    }
    
    method reconectarControles() {
        configTeclado.gameOn()
    }
    
    method ganarPuntos(puntos) {
        puntaje += puntos
    }
    
    method nivelActual() = nivelActual
    method cambiarNivel(nuevoNivel) {
        nivelActual = nuevoNivel
    }
    
    // Método necesario para el polimorfismo de interacciones
    method interactuarConPersonaje(pc) {
        // El player no hace nada especial al interactuar consigo mismo
    }
}

class Pincho {
    var property position = game.at(0, 0)
    
    method image() = "pincho.jpg"
    
    method interactuarConPersonaje(pc) {
        pc.perderVida()
    }
}

class Meta {
    var property position = game.at(0, 0)

    method image() = "meta.jpg"
    
    method interactuarConPersonaje(pc) {
        pc.ganarPuntos(500)
        game.say(pc, "¡Nivel completado! Puntaje: " + pc.puntaje())
        
        // Pasar al siguiente nivel después de 2 segundos
        game.schedule(2000, {
            juegoFLDSMDFR.siguienteNivel()
        })
    }
}