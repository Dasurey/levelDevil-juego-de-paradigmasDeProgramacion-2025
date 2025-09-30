import FLDSMDFR.*
import menuYTeclado.*

//*==========================| Niveles |==========================
object nivel1 {
    const property siguienteNivel = endOfTheGame
    
    method iniciar() {
        // Limpiar pantalla
        juegoFLDSMDFR.clear()
        
        // Agregar player
        game.addVisual(player)
        player.position(game.at(1, 1))
        
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
}

object endOfTheGame {
    method iniciar() {
        juegoFLDSMDFR.clear()
        game.say(player, "¡Juego completado!")
        game.schedule(3000, {
            game.stop()
        })
    }
}