(define (domain Ejercicio6)
	(:requirements :strips :typing :fluents)
	(:types
			Agente - Player
			DiCaprio Princesa Principe Profesor Bruja - Personaje
			Oscar Oro Algoritmo Manzana Rosa Bikini Zapatillas - Objeto
			Zona - Zona
			Orientacion - Orientacion
			Tipo - TipoTerreno)
	(:predicates
		(PosicionJugador ?j - Player ?z - Zona)
		(PosicionObjeto ?o - Objeto ?z - Zona)
		(PosicionPersonaje ?p - Personaje ?z - Zona)
		(OrientacionJugador ?ori - Orientacion ?j - Player)
		(Conexion ?z1 - Zona ?z2 - Zona ?ori - Orientacion)
		(ObjetoCogido ?o - Objeto ?j - Player)
		(ManoLibre ?j - Player)
		(MochilaLibre ?j - Player)
		(ObjetoEnLaMochila ?o - Objeto ?j - Player)
		(TipoZona ?z - Zona ?t - TipoTerreno)
		(ObjetoTerreno ?t - TipoTerreno ?o - Objeto)
		(TerrenoSinEquipamiento ?t - TipoTerreno)
		(esZapatilla ?o)
		(esBikini ?o)
	)

	(:functions
		(CosteDesplazamiento)
		(DistanciaZonas ?z1 ?z2 - Zona)
		(PuntosTotales)
		(PuntosObjetoPersonaje	?o - Objeto ?p - Personaje)
		(CapacidadBolsillo ?p - Personaje)
		(ObjetosBolsillo ?p - Personaje)
		(PuntosJugador ?j - Player)
	)

	(:action GirarIzquierda
    :parameters (?ori - Orientacion ?j - Player)
    :precondition (and (OrientacionJugador ?ori ?j))
    :effect
    (and
        (when (and (OrientacionJugador Norte ?j))
            (and (OrientacionJugador Oeste ?j) (not (OrientacionJugador Norte ?j)))
        )
				(when (and (OrientacionJugador Sur ?j))
						(and (OrientacionJugador Este ?j) (not (OrientacionJugador Sur ?j)))
				)
        (when (and (OrientacionJugador Oeste ?j))
            (and (OrientacionJugador Sur ?j) (not (OrientacionJugador Oeste ?j)))
        )
        (when (and (OrientacionJugador Este ?j))
            (and (OrientacionJugador Norte ?j) (not (OrientacionJugador Este ?j)))
        )
    )
  )

	(:action GirarDerecha
    :parameters (?ori - Orientacion ?j - Player)
    :precondition (and (OrientacionJugador ?ori ?j))
    :effect
    (and
        (when (and (OrientacionJugador Norte ?j))
            (and (OrientacionJugador Este ?j) (not (OrientacionJugador Norte ?j)))
        )
				(when (and (OrientacionJugador Sur ?j))
						(and (OrientacionJugador Oeste ?j) (not (OrientacionJugador Sur ?j)))
				)
        (when (and (OrientacionJugador Oeste ?j))
            (and (OrientacionJugador Norte ?j) (not (OrientacionJugador Oeste ?j)))
        )
        (when (and (OrientacionJugador Este ?j))
            (and (OrientacionJugador Sur ?j) (not (OrientacionJugador Este ?j)))
        )
    )
  )

	(:action Ir
    :parameters (?z1 - Zona ?z2 - Zona ?j - Player ?ori - Orientacion ?t - TipoTerreno ?o - Objeto)
    :precondition (and
			(PosicionJugador ?j ?z1)
			(not (PosicionJugador ?j ?z2))
			(OrientacionJugador ?ori ?j)
			(Conexion ?z1 ?z2 ?ori)
			(TipoZona ?z2 ?t)
			(or
				(TerrenoSinEquipamiento ?t)
				(and
					(or
						(ObjetoCogido ?o ?j)
						(ObjetoEnLaMochila ?o ?j))
					(ObjetoTerreno ?t ?o))
				)
			)
    :effect (and
			(PosicionJugador ?j ?z2)
			(not (PosicionJugador ?j ?z1))
			(increase (CosteDesplazamiento) (DistanciaZonas ?z1 ?z2)))
  )

	(:action Coger
    :parameters (?o - Objeto ?j - Player ?z - Zona)
    :precondition (and
			(PosicionJugador ?j ?z)
			(PosicionObjeto ?o ?z)
			(ManoLibre ?j))
    :effect (and
			(not (ManoLibre ?j))
			(ObjetoCogido ?o ?j)
			(not (PosicionObjeto ?o ?z)))
	)

	(:action Dejar
    :parameters (?o - Objeto ?j - Player ?z - Zona)
    :precondition (and
			(PosicionJugador ?j ?z)
			(ObjetoCogido ?o ?j))
    :effect (and
			(ManoLibre ?j)
			(not (ObjetoCogido ?o ?j))
			(PosicionObjeto ?o ?z))
  )

	(:action Entregar
    :parameters (?o - Objeto ?j - Player ?z - Zona ?p - Personaje)
    :precondition (and
			(PosicionJugador ?j ?z)
			(PosicionPersonaje ?p ?z)
			(ObjetoCogido ?o ?j)
			(not (esZapatilla ?o))
			(not (esBikini ?o))
			(> (CapacidadBolsillo ?p) (ObjetosBolsillo ?p)))
    :effect (and
			(not (ObjetoCogido ?o ?j))
			(increase (PuntosJugador ?j) (PuntosObjetoPersonaje ?o ?p))
			(ManoLibre ?j)
			(increase (PuntosTotales) (PuntosObjetoPersonaje ?o ?p))
			(increase (ObjetosBolsillo ?p) 1))
  )

	(:action MeterEnMochila
		:parameters (?o - Objeto ?j - Player)
		:precondition (and
			(MochilaLibre ?j)
			(ObjetoCogido ?o ?j))
		:effect (and
			(ObjetoEnLaMochila ?o ?j)
			(not (ObjetoCogido ?o ?j))
			(not (MochilaLibre ?j))
			(ManoLibre ?j))
	)

	(:action SacarDeMochila
	  :parameters (?o - Objeto ?j - Player)
	  :precondition (and
			(ObjetoEnLaMochila ?o ?j)
			(ManoLibre ?j))
	  :effect (and
			(not (ManoLibre ?j))
			(MochilaLibre ?j)
			(ObjetoCogido ?o ?j)
			(not (ObjetoEnLaMochila ?o ?j)))
	)
)
