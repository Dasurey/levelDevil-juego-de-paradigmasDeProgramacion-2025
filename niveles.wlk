import levelDevil.*
import teclado.*

//*==========================| Niveles |==========================

class NivelBase {
    method crearParedes(positiones) {
        positiones.forEach({ pos =>
            game.addVisual(new Pared(position = pos))
        })
    }

    method crearPinchos(positiones) {
        positiones.forEach({ pos =>
            game.addVisual(new Pincho(position = pos))
        })
    }

    method agregarMeta(pos) {
        const meta = new Meta(position = pos)
        game.addVisual(meta)
    }
}


object nivel1 inherits NivelBase {
    const property siguienteNivel = nivel2
    
    method iniciar() {
        // Limpiar pantalla
        gestorNiveles.limpiar()

        /*
        // Agregar algunos pinchos
        const pincho1 = new Pincho(position = game.at(3, 3))
        const pincho2 = new Pincho(position = game.at(5, 2))
        const pincho3 = new Pincho(position = game.at(7, 4))
        
        game.addVisual(pincho1)
        game.addVisual(pincho2)
        game.addVisual(pincho3)
        */
        // Agregar paredes usando helper
        self.crearParedes([
            game.at(1,7), game.at(2,7), game.at(3,7), game.at(4,7),
            game.at(5,7), game.at(6,7), game.at(7,7), game.at(8,7),
            game.at(9,7), game.at(4,6), game.at(9,6), game.at(1,5), 
            game.at(6,5), game.at(7,5), game.at(9,5),
            game.at(1,4), game.at(2,4), game.at(4,4), game.at(5,3), game.at(7,4),
            game.at(4,3), game.at(6,3), game.at(7,3), game.at(8,3),
            game.at(1,2), game.at(2,2), game.at(4,2), game.at(1,1), 
            game.at(6,1), game.at(7,1), game.at(8,1), game.at(1,0),
            game.at(2,0), game.at(3,0), game.at(5,0), game.at(6,0), 
            game.at(8,0), game.at(9,0), game.at(9,1)
        ])
        
        game.addVisual(pinchoInvisible)

        game.onTick(100, "mostrarPincho", {
        const dx = (jugador.position().x() - pinchoInvisible.position().x()).abs()
        const dy = (jugador.position().y() - pinchoInvisible.position().y()).abs()

        if (dx == 1 and dy == 1) {
            game.removeVisual(pinchoInvisible)
            game.addVisual(new Pincho(position = pinchoInvisible.position()))
        }
        })

        pinchoMovil.position(game.at(1, 3))
        game.addVisual(pinchoMovil)

        // el pincho cada se mueve cada 0,3 seg
        game.onTick(300, "moverPinchoMovil", {
            pinchoMovil.moverseAleatoriamente()
        })

        // Agregar meta
        self.agregarMeta(game.at(10,4))

        // Agregar jugador
        game.addVisual(jugador)
        jugador.position(game.at(0, 6))
    }
}

object nivel2 inherits NivelBase {
    const property siguienteNivel = endOfTheGame
    
    method iniciar() {
        // Limpiar pantalla
        gestorNiveles.limpiar()

        // Agregar paredes usando helper
        self.crearParedes([
            game.at(1,7), game.at(2,7), game.at(0,7), game.at(8,7),
            game.at(9,7), game.at(1,6), game.at(4,6), game.at(5,6),
            game.at(6,6), game.at(0,5), game.at(3,5), game.at(7,5), 
            game.at(0,4), game.at(2,4), game.at(5,4),
            game.at(7,4), game.at(8,4), game.at(4,3), game.at(1,2), game.at(3,2),
            game.at(4,3), game.at(8,3),
            game.at(4,2), game.at(6,2), game.at(4,1), game.at(8,1), 
            game.at(9,1)
        ])
        
        game.addVisual(pinchoInvisible)

        game.onTick(100, "mostrarPincho", {
        const dx = (jugador.position().x() - pinchoInvisible.position().x()).abs()
        const dy = (jugador.position().y() - pinchoInvisible.position().y()).abs()

        if (dx <= 1 and dy <= 1) {
            game.removeVisual(pinchoInvisible)
            game.addVisual(new Pincho(position = pinchoInvisible.position()))
        }
        })

        // cada dos segundos muevo la caja
        game.onTick(2000, "movimiento", { caja.movete() })
        //

        // Agregar meta
        self.agregarMeta(game.at(5,7))

        // Agregar jugador
        game.addVisual(jugador)
        jugador.position(game.at(5, 0))
    }
}

object endOfTheGame inherits NivelBase {
    method iniciar() {
        gestorNiveles.limpiar()
        game.say(jugador, "¡Juego completado!")
        game.schedule(3000, {
            game.stop()
        })
    }
}
