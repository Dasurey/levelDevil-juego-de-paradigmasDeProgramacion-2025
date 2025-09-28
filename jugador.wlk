// Jugador principal
object jugador {
    var property position = game.at(1, 1)
    var property vidas = 3
    var property puntaje = 0
    var nivelActual = 1
    
    method image() = "jugador.jpg"
    
    method mover(direccion) {
        const nuevaPosicion = direccion.calcularNuevaPosicion(position)
        if (self.puedeMoverse(nuevaPosicion)) {
            position = nuevaPosicion
            game.say(self, "Posición: " + position.x() + "," + position.y())
            self.verificarInteracciones()
        }
    }
    
    method puedeMoverse(nuevaPosicion) {
        return nuevaPosicion.x().between(0, game.width() - 1) and 
               nuevaPosicion.y().between(0, game.height() - 1)
    }
    
    method verificarInteracciones() {
        const objetosEnColision = game.colliders(self)
        objetosEnColision.forEach { obj => 
            if (obj.className() == "Pincho") {
                self.perderVida()
                game.say(self, "¡Auch! Perdiste una vida")
            }
            if (obj.className() == "Meta") {
                self.ganarPuntos(500)
                game.say(self, "¡Nivel completado! +500 puntos")
            }
        }
    }
    
    method perderVida() {
        vidas -= 1
        if (vidas <= 0) {
            game.say(self, "¡Game Over!")
            // Reiniciar o terminar juego
        } else {
            self.respawnear()
        }
    }
    
    method respawnear() {
        position = game.at(1, 1) // Posición inicial por defecto
        game.say(self, "Vidas restantes: " + vidas)
    }
    
    method ganarPuntos(puntos) {
        puntaje += puntos
    }
    
    method nivelActual() = nivelActual
    method cambiarNivel(nuevoNivel) {
        nivelActual = nuevoNivel
    }
}

// Sistema de direcciones usando Strategy Pattern
object arriba {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.up(1)
    }
    
    method opuesto() = abajo
}

object abajo {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.down(1)
    }
    
    method opuesto() = arriba
}

object izquierda {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.left(1)
    }
    
    method opuesto() = derecha
}

object derecha {
    method calcularNuevaPosicion(posicionActual) {
        return posicionActual.right(1)
    }
    
    method opuesto() = izquierda
}