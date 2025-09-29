// Jugador principal
object jugador {
    var property position = game.at(1, 1)
    var property vidas = 1
    var property puntaje = 0
    var nivelActual = 1
    const posicionInicial = game.at(1, 1)
    
    method image() = "jugador.jpg"
    
    method mover(direccion) {
        const nuevaPosicion = direccion.calcularNuevaPosicion(position)
        if (self.puedeMoverse(nuevaPosicion)) {
            position = nuevaPosicion
            self.verificarInteracciones()
        }
    }
    
    method puedeMoverse(nuevaPosicion) {
        return nuevaPosicion.x().between(0, game.width() - 1) and 
               nuevaPosicion.y().between(0, game.height() - 1)
    }
    
    method verificarInteracciones() {
        const objetosEnPosicion = game.getObjectsIn(position)
        
        // Debug: mostrar cuántos objetos hay
        game.say(self, "Objetos en posición: " + objetosEnPosicion.size())
        
        // Verificar cada objeto individualmente
        objetosEnPosicion.forEach { obj => 
            const nombreClase = obj.className()
            game.say(self, "Objeto: " + nombreClase)
            
            // Detectar trampas y elementos por separado
            if (nombreClase === "trampas.Pincho") {
                game.say(self, "¡ES UN PINCHO!")
                self.perderVida()
            }
            
            if (nombreClase === "elementos.Meta") {
                puntaje += 500
                game.say(self, "¡Nivel completado! Puntaje: " + puntaje)
            }
        }
    }
    
    method perderVida() {
        game.say(self, "¡Método perderVida ejecutado!")
        self.respawnear()
    }
    
    method respawnear() {
        position = posicionInicial
        game.say(self, "¡De vuelta al inicio!")
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