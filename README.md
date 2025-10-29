UTN - Facultad Regional Buenos Aires - Materia Paradigmas de Programación

## Equipo de desarrollo:

- Completar

## Introducción

- Completar descripción del juego

## Capturas

- Completar

## Reglas de Juego / Instrucciones

### Instrucciones del juego

- Completar

### Controles:

- Completar

## Explicaciones teóricas y diagramas

- Completar Link a .md




```wollok
// levelDevil.wlk
object jugador {
    var property position = game.at(0, 6)
    var vidas = 1
    var puntaje = 0
    var puntajeTemporalGanado = 0
    var puntajeTemporalPerdido = 0

    method reiniciarVidas() {
        vidas = 1
    }
    
    const imagenes = ["JugadorLevelDevil_V1.png", "ExplosionAlMorir.gif"]
    var property image = imagenes.first()
    method esPisable() = true

    method esMeta() = false

    method mover(direccion) {
        if (gestorTeclado.configActual.controlesHabilitados()) {
            const nuevaPosition = direccion.calcularNuevaPosition(self.position())
            self.position(nuevaPosition)
        }
    }

    method morir() {
        vidas -= 1
        if (vidas <= 0) {
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
            game.say(self, "¡Has perdido una vida! Vidas restantes: " + vidas)
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
```

```wollok
// tecladoYMenu.wlk
//          Configuraciones de Teclado
class ConfigTecladoBase {
    var controlesHabilitados = true

    method controlesHabilitados() = controlesHabilitados

    method iniciar() {
        keyboard.up().onPressDo({ jugador.mover(self.teclaArriba()) }) // aca en vez de jugador habria que poner un gestor de que jugador esta.
        keyboard.down().onPressDo({ jugador.mover(self.teclaAbajo()) })
        keyboard.left().onPressDo({ jugador.mover(self.teclaIzquierda()) })
        keyboard.right().onPressDo({ jugador.mover(self.teclaDerecha()) })
        keyboard.r().onPressDo({ gestorNiveles.reiniciarNivel() })
    }
    
    method teclaArriba() = arriba
    method teclaAbajo() = abajo
    method teclaIzquierda() = izquierda
    method teclaDerecha() = derecha

    

    method juegoEnMarcha() {
        controlesHabilitados = true
    }

    method juegoBloqueado() {
        controlesHabilitados = false
    }
}
```