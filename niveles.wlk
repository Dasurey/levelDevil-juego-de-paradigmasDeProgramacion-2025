import jugador.*
import trampas.*

// Manager de niveles simplificado
object nivelManager {
    var property nivelActual = 1
    
    method inicializar() {
        self.cargarNivel1()
    }
    
    method cargarNivel1() {
        // Limpiar pantalla
        game.allVisuals().forEach { visual => game.removeVisual(visual) }
        
        // Agregar jugador
        game.addVisual(jugador)
        jugador.position(game.at(1, 1))
        
        // Agregar algunos pinchos
        const pincho1 = new Pincho(position = game.at(3, 3))
        const pincho2 = new Pincho(position = game.at(5, 2))
        const pincho3 = new Pincho(position = game.at(7, 4))
        
        game.addVisual(pincho1)
        game.addVisual(pincho2)
        game.addVisual(pincho3)
        
        // Agregar meta
        const meta = new Meta(position = game.at(8, 8))
        game.addVisual(meta)
    }
    
    method reiniciarNivel() {
        self.cargarNivel1()
    }
}

// Fin del archivo