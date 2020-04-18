(define (problem Ejercicio7-1)
	(:domain Ejercicio7)
	(:objects
		princesa - Princesa
		principe - Principe
		bruja - Bruja
		profesor - Profesor
		diCaprio - DiCaprio
		oscar - Oscar
		manzana - Manzana
		rosa - Rosa
		algoritmo - Algoritmo
		oro - Oro
		bikini - Bikini
		zapatillas - Zapatillas
		Agente1 - Dealer
		Agente2 - Picker
		z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 - Zona
		Norte Sur Este Oeste - Orientacion
		Bosque Agua Precipicio Arena Piedra - TipoTerreno
	)
	(:init
		(Conexion z1 z2 Este)
		(Conexion z2 z1 Oeste)
		(= (DistanciaZonas z1 z2) 1)
		(= (DistanciaZonas z2 z1) 1)
		(Conexion z2 z3 Este)
		(Conexion z3 z2 Oeste)
		(= (DistanciaZonas z2 z3) 3)
		(= (DistanciaZonas z3 z2) 3)
		(Conexion z3 z4 Este)
		(Conexion z4 z3 Oeste)
		(= (DistanciaZonas z3 z4) 3)
		(= (DistanciaZonas z3 z4) 3)
		(Conexion z4 z5 Este)
		(Conexion z5 z4 Oeste)
		(= (DistanciaZonas z4 z5) 10)
		(= (DistanciaZonas z5 z4) 10)
		(Conexion z5 z6 Este)
		(Conexion z6 z5 Oeste)
		(= (DistanciaZonas z5 z6) 1)
		(= (DistanciaZonas z6 z5) 1)
		(Conexion z2 z7 Norte)
		(Conexion z7 z2 Sur)
		(= (DistanciaZonas z2 z7) 10)
		(= (DistanciaZonas z7 z2) 10)
		(Conexion z7 z8 Este)
		(Conexion z8 z7 Oeste)
		(= (DistanciaZonas z7 z8) 2)
		(= (DistanciaZonas z8 z7) 2)
		(Conexion z3 z8 Norte)
		(Conexion z8 z3 Sur)
		(= (DistanciaZonas z3 z8) 2)
		(= (DistanciaZonas z8 z3) 2)
		(Conexion z3 z14 Sur)
		(Conexion z14 z3 Norte)
		(= (DistanciaZonas z3 z14) 1)
		(= (DistanciaZonas z14 z3) 1)
		(Conexion z4 z15 Sur)
		(Conexion z15 z4 Norte)
		(= (DistanciaZonas z4 z15) 2)
		(= (DistanciaZonas z15 z4) 2)
		(Conexion z5 z11 Norte)
		(Conexion z11 z5 Sur)
		(= (DistanciaZonas z5 z11) 1)
		(= (DistanciaZonas z11 z5) 1)
		(Conexion z6 z25 Norte)
		(Conexion z25 z6 Sur)
		(= (DistanciaZonas z6 z25) 7)
		(= (DistanciaZonas z25 z6) 7)
		(Conexion z15 z23 Este)
		(Conexion z23 z15 Oeste)
		(= (DistanciaZonas z15 z23) 1)
		(= (DistanciaZonas z23 z15) 1)
		(Conexion z23 z24 Este)
		(Conexion z24 z23 Oeste)
		(= (DistanciaZonas z23 z24) 3)
		(= (DistanciaZonas z24 z23) 3)
		(Conexion z6 z24 Sur)
		(Conexion z24 z6 Norte)
		(= (DistanciaZonas z6 z24) 2)
		(= (DistanciaZonas z24 z6) 2)
		(Conexion z7 z13 Norte)
		(Conexion z13 z7 Sur)
		(= (DistanciaZonas z7 z13) 7)
		(= (DistanciaZonas z13 z7) 7)
		(Conexion z8 z9 Norte)
		(Conexion z9 z8 Sur)
		(= (DistanciaZonas z8 z9) 3)
		(= (DistanciaZonas z9 z8) 3)
		(Conexion z13 z9 Este)
		(Conexion z9 z13 Oeste)
		(= (DistanciaZonas z13 z9) 1)
		(= (DistanciaZonas z9 z13) 1)
		(Conexion z9 z10 Este)
		(Conexion z10 z9 Oeste)
		(= (DistanciaZonas z9 z10) 2)
		(= (DistanciaZonas z10 z9) 2)
		(Conexion z10 z16 Este)
		(Conexion z16 z10 Oeste)
		(= (DistanciaZonas z10 z16) 3)
		(= (DistanciaZonas z16 z10) 3)
		(Conexion z19 z20 Este)
		(Conexion z20 z19 Oeste)
		(= (DistanciaZonas z19 z20) 9)
		(= (DistanciaZonas z20 z19) 9)
		(Conexion z20 z21 Este)
		(Conexion z21 z20 Oeste)
		(= (DistanciaZonas z20 z21) 10)
		(= (DistanciaZonas z21 z20) 10)
		(Conexion z13 z17 Norte)
		(Conexion z17 z13 Sur)
		(= (DistanciaZonas z13 z17) 1)
		(= (DistanciaZonas z17 z13) 1)
		(Conexion z9 z18 Norte)
		(Conexion z18 z9 Sur)
		(= (DistanciaZonas z9 z18) 1)
		(= (DistanciaZonas z18 z9) 1)
		(Conexion z18 z19 Norte)
		(Conexion z19 z18 Sur)
		(= (DistanciaZonas z18 z19) 3)
		(= (DistanciaZonas z19 z18) 3)
		(Conexion z10 z12 Norte)
		(Conexion z12 z10 Sur)
		(= (DistanciaZonas z10 z12) 7)
		(= (DistanciaZonas z12 z10) 7)
		(Conexion z16 z22 Norte)
		(Conexion z22 z16 Sur)
		(= (DistanciaZonas z16 z22) 4)
		(= (DistanciaZonas z22 z16) 4)
		(Conexion z22 z21 Norte)
		(Conexion z21 z22 Sur)
		(= (DistanciaZonas z22 z21) 5)
		(= (DistanciaZonas z21 z22) 5)
		(PosicionObjeto oscar z2)
		(PosicionObjeto manzana z8)
		(PosicionObjeto rosa z18)
		(PosicionObjeto algoritmo z15)
		(PosicionObjeto oro z22)
		(PosicionPersonaje princesa z21)
		(PosicionPersonaje principe z16)
		(PosicionPersonaje bruja z12)
		(PosicionPersonaje profesor z11)
		(PosicionPersonaje diCaprio z17)
		(PosicionJugador Agente1 z1)
		(OrientacionJugador Norte Agente1)
		(PosicionJugador Agente2 z20)
		(OrientacionJugador Sur Agente2)
		(ManoLibre Agente1)
		(ManoLibre Agente2)
		(= (CosteDesplazamiento) 0)

		(TipoZona z1 Arena)
		(TipoZona z2 Arena)
		(TipoZona z3 Arena)
		(TipoZona z4 Agua)
		(TipoZona z5 Bosque)
		(TipoZona z6 Piedra)
		(TipoZona z7 Precipicio)
		(TipoZona z8 Arena)
		(TipoZona z9 Piedra)
		(TipoZona z10 Arena)
		(TipoZona z11 Arena)
		(TipoZona z12 Piedra)
		(TipoZona z13 Arena)
		(TipoZona z14 Arena)
		(TipoZona z15 Arena)
		(TipoZona z16 Arena)
		(TipoZona z17 Piedra)
		(TipoZona z18 Arena)
		(TipoZona z19 Arena)
		(TipoZona z20 Piedra)
		(TipoZona z21 Piedra)
		(TipoZona z22 Arena)
		(TipoZona z23 Precipicio)
		(TipoZona z24 Piedra)
		(TipoZona z25 Arena)
		(PosicionObjeto bikini z9)
		(PosicionObjeto zapatillas z4)
		(esBikini bikini)
		(esZapatilla zapatillas)
		(ObjetoTerreno Agua bikini)
		(ObjetoTerreno Bosque zapatillas)
		(TerrenoSinEquipamiento Arena)
		(TerrenoSinEquipamiento Piedra)
		(MochilaLibre Agente1)
		(MochilaLibre Agente2)

		(= (PuntosObjetoPersonaje oscar diCaprio) 10)
		(= (PuntosObjetoPersonaje rosa diCaprio) 1)
		(= (PuntosObjetoPersonaje manzana diCaprio) 3)
		(= (PuntosObjetoPersonaje algoritmo diCaprio) 4)
		(= (PuntosObjetoPersonaje oro diCaprio) 5)
		(= (PuntosObjetoPersonaje oscar princesa) 5)
		(= (PuntosObjetoPersonaje rosa princesa) 10)
		(= (PuntosObjetoPersonaje manzana princesa) 1)
		(= (PuntosObjetoPersonaje algoritmo princesa) 3)
		(= (PuntosObjetoPersonaje oro princesa) 4)
		(= (PuntosObjetoPersonaje oscar bruja) 4)
		(= (PuntosObjetoPersonaje rosa bruja) 5)
		(= (PuntosObjetoPersonaje manzana bruja) 10)
		(= (PuntosObjetoPersonaje algoritmo bruja) 1)
		(= (PuntosObjetoPersonaje oro bruja) 3)
		(= (PuntosObjetoPersonaje oscar profesor) 3)
		(= (PuntosObjetoPersonaje rosa profesor) 4)
		(= (PuntosObjetoPersonaje manzana profesor) 5)
		(= (PuntosObjetoPersonaje algoritmo profesor) 10)
		(= (PuntosObjetoPersonaje oro profesor) 1)
		(= (PuntosObjetoPersonaje oscar principe) 1)
		(= (PuntosObjetoPersonaje rosa principe) 3)
		(= (PuntosObjetoPersonaje manzana principe) 4)
		(= (PuntosObjetoPersonaje algoritmo principe) 5)
		(= (PuntosObjetoPersonaje oro principe) 10)
		(= (PuntosTotales) 0)

		(= (CapacidadBolsillo bruja) 4)
		(= (ObjetosBolsillo bruja) 0)
		(= (CapacidadBolsillo princesa) 3)
		(= (ObjetosBolsillo princesa) 0)
		(= (CapacidadBolsillo principe) 3)
		(= (ObjetosBolsillo principe) 0)
		(= (CapacidadBolsillo profesor) 3)
		(= (ObjetosBolsillo profesor) 0)
		(= (CapacidadBolsillo diCaprio) 2)
		(= (ObjetosBolsillo diCaprio) 0)

		(= (PuntosJugador Agente1) 0)
	)
	(:goal
		(and (>= (PuntosTotales) 40))
	)
	(:metric minimize (CosteDesplazamiento))
)
