(define (domain Ejercicio1)
	(:requirements :strips :typing)
	(:types
		Agente - Player
		DiCaprio Princesa Principe Profesor Bruja - Personaje
		Oscar Oro Algoritmo Manzana Rosa - Objeto
		Zona - Zona
		Orientacion - Orientacion)

	(:predicates
		(PosicionJugador ?j - Player ?z - Zona)
		(PosicionObjeto ?o - Objeto ?z - Zona)
		(PosicionPersonaje ?p - Personaje ?z - Zona)
		(OrientacionJugador ?ori - Orientacion)
		(Conexion ?z1 - Zona ?z2 - Zona ?ori - Orientacion)
		(ObjetoCogido ?o - Objeto)
		(TieneObjeto ?p - Personaje)
		(ManoLibre)
	)

	(:action GirarIzquierda
        :parameters (?ori - Orientacion)
        :precondition (and (OrientacionJugador ?ori))
        :effect
        (and
            (when (and (OrientacionJugador Norte))
                (and (OrientacionJugador Oeste)
							 		(not (OrientacionJugador Norte)))
            )
						(when (and (OrientacionJugador Sur))
								(and (OrientacionJugador Este)
									(not (OrientacionJugador Sur)))
						)
            (when (and (OrientacionJugador Oeste))
                (and (OrientacionJugador Sur)
									(not (OrientacionJugador Oeste)))
            )
            (when (and (OrientacionJugador Este))
                (and (OrientacionJugador Norte)
									(not (OrientacionJugador Este)))
            )
        )
  )

	(:action GirarDerecha
        :parameters (?ori - Orientacion)
        :precondition (and (OrientacionJugador ?ori))
        :effect
        (and
            (when (and (OrientacionJugador Norte))
                (and (OrientacionJugador Este)
									(not (OrientacionJugador Norte)))
            )
						(when (and (OrientacionJugador Sur))
								(and (OrientacionJugador Oeste)
									(not (OrientacionJugador Sur)))
						)
            (when (and (OrientacionJugador Oeste))
                (and (OrientacionJugador Norte)
									(not (OrientacionJugador Oeste)))
            )
            (when (and (OrientacionJugador Este))
                (and (OrientacionJugador Sur)
									(not (OrientacionJugador Este)))
            )
        )
  )

	(:action Ir
        :parameters (?z1 - Zona ?z2 - Zona ?j - Player ?ori - Orientacion)
        :precondition	(and
					(PosicionJugador ?j ?z1)
					(not (PosicionJugador ?j ?z2))
					(Conexion ?z1 ?z2 ?ori)
					(OrientacionJugador ?ori))
        :effect (and
					(PosicionJugador ?j ?z2)
					(not (PosicionJugador ?j ?z1)))
  )

	(:action Coger
        :parameters (?o - Objeto ?j - Player ?z - Zona)
        :precondition	(and
					(PosicionJugador ?j ?z)
					(PosicionObjeto ?o ?z)
					(ManoLibre))
        :effect (and
					(not (ManoLibre))
					(ObjetoCogido ?o)
					(not (PosicionObjeto ?o ?z)))
	)

	(:action Dejar
        :parameters (?o - Objeto ?j - Player ?z - Zona)
        :precondition (and
					(PosicionJugador ?j ?z)
					(ObjetoCogido ?o))
        :effect	(and
					(ManoLibre)
					(not (ObjetoCogido ?o))
					(PosicionObjeto ?o ?z))
  )

	(:action Entregar
        :parameters (?o - Objeto ?j - Player ?z - Zona ?p - Personaje)
        :precondition (and
					(not (TieneObjeto ?p))
					(PosicionJugador ?j ?z)
					(PosicionPersonaje ?p ?z)
					(ObjetoCogido ?o))
        :effect (and
					(not (ObjetoCogido ?o))
					(TieneObjeto ?p)
					(ManoLibre))
  )
)
