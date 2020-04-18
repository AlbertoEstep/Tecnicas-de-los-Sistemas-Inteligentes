(define (domain zeno-travel)
 (:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :universal-preconditions
  :disjuntive-preconditions
  :conditional-effects
  :htn-expansion
  :durative-actions
  :metatags
 )

(:types aircraft person city - object)

(:constants slow fast - object)

(:predicates 
	(at ?x - (either person aircraft) ?c - city)
	(in ?p - person ?a - aircraft)
	(different ?x ?y) 
	(igual ?x ?y)
	(hay-fuel-para-viaje-rapido ?a ?c1 ?c2)
	(hay-fuel-para-viaje-lento ?a ?c1 ?c2)
	(limite-permitido-lento ?a ?c1 ?c2)
	(limite-permitido-rapido ?a ?c1 ?c2))

(:functions (fuel ?a - aircraft)
            (distance ?c1 - city ?c2 - city)
            (slow-speed ?a - aircraft)
            (fast-speed ?a - aircraft)
            (slow-burn ?a - aircraft)
            (fast-burn ?a - aircraft)
            (capacity ?a - aircraft)
            (refuel-rate ?a - aircraft)
            (total-fuel-used)
            (boarding-time)
            (debarking-time)
            (fuel-limit))

(:derived
  (igual ?x ?x) ())

(:derived 
  (different ?x ?y) (not (igual ?x ?y)))

(:derived
  (hay-fuel-para-viaje-rapido ?a - aircraft ?c1 - city ?c2 - city)
  (>= (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a))))

(:derived
  (hay-fuel-para-viaje-lento ?a - aircraft ?c1 - city ?c2 - city)
  (>= (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a))))

(:derived
  (limite-permitido-rapido ?a - aircraft ?c1 - city ?c2 - city)
  (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a)))))

(:derived
  (limite-permitido-lento ?a - aircraft ?c1 - city ?c2 - city)
  (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a)))))

(:task transport-person
	:parameters (?p - person ?c - city)

	(:method Case1
		:precondition (at ?p ?c)
		:tasks ())

	(:method Case2
		:precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c1 - city))
		:tasks ((board ?p ?a ?c1)(mover-avion ?a ?c1 ?c)(debark ?p ?a ?c )))

	(:method Case3
		:precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c2 - city) (different ?c1 ?c2))
 	  	:tasks ((mover-avion ?a ?c2 ?c1) (board ?p ?a ?c1) (mover-avion ?a ?c1 ?c) (debark ?p ?a ?c))))


(:task mover-avion
	:parameters (?a - aircraft ?c1 - city ?c2 -city)

	(:method fuel-suficiente-para-viaje-rapido
		:precondition (and (hay-fuel-para-viaje-rapido ?a ?c1 ?c2) (different ?c1 ?c2) (limite-permitido-rapido ?a ?c1 ?c2))
		:tasks ((zoom ?a ?c1 ?c2)))

	(:method no-fuel-para-viaje-rapido
		:precondition (and (not (hay-fuel-para-viaje-rapido ?a ?c1 ?c2)) (different ?c1 ?c2) (limite-permitido-rapido ?a ?c1 ?c2))
		:tasks ((refuel ?a ?c1) (zoom ?a ?c1 ?c2)))

	(:method fuel-suficiente-para-viaje-lento
		:precondition (and (hay-fuel-para-viaje-lento ?a ?c1 ?c2) (different ?c1 ?c2) (limite-permitido-lento ?a ?c1 ?c2))
		:tasks ((fly ?a ?c1 ?c2)))

	(:method no-fuel-para-viaje-lento
		:precondition (and (not (hay-fuel-para-viaje-lento ?a ?c1 ?c2)) (different ?c1 ?c2) (limite-permitido-lento ?a ?c1 ?c2))
		:tasks ((refuel ?a ?c1) (fly ?a ?c1 ?c2))))
 
(:import "Primitivas-Zenotravel.pddl") 

)
