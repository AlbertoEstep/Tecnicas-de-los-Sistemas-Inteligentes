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
	(hay-fuel-para-viaje-rapido ?a ?c1 ?c2)
	(hay-fuel-para-viaje-lento ?a ?c1 ?c2)
	(limite-permitido-lento ?a ?c1 ?c2)
	(limite-permitido-rapido ?a ?c1 ?c2)
	(destino ?p - person ?c - city))

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
            (fuel-limit)
            (n-pasajeros ?a - aircraft)
            (n-pasajeros-max ?a - aircraft)
            (duracion ?a - aircraft)
            (max-duracion ?a - aircraft))

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
	:parameters ()
  (:method Case1 
   :precondition (and (in ?p1 - person ?a1 - aircraft) (at ?a1 - aircraft ?c1 - city) (destino ?p1 - person ?c2 - city) (= ?c1 ?c2))
   :tasks ((debark ?p1 ?a1 ?c2) (transport-person)))

  (:method Case2
    :precondition (and (at ?p1 - person ?c1 - city) (at ?a1 - aircraft ?c2 - city) (destino ?p1 - person ?c3 - city) (= ?c2 ?c3) (not(= ?c1 ?c2)))
    :tasks((mover-avion ?a1 ?c2 ?c1) (board ?p1 ?a1 ?c1) (transport-person)))

  (:method Case3
    :precondition (and (at ?p1 - person ?c1 - city) (at ?a1 - aircraft ?c2 - city) (destino ?p1 - person ?c3 - city) (not(= ?c1 ?c2)) (not(= ?c1 ?c3)) (not(= ?c3 ?c2)))
    :tasks((mover-avion ?a1 ?c2 ?c1) (board ?p1 ?a1 ?c1) (transport-person)))

  (:method Case4 
   :precondition (and (at ?p1 - person ?c1 - city) (at ?a1 - aircraft ?c2 - city) (destino ?p1 - person ?c3 - city) (= ?c1 ?c2) (not(= ?c2 ?c3)))
   :tasks ((board ?p1 ?a1 ?c1) (transport-person)))

  (:method Case5 
   :precondition (and (in ?p1 - person ?a1 - aircraft) (at ?a1 - aircraft ?c1 - city) (destino ?p1 - person ?c2 - city) (not (= ?c1 ?c2)))
   :tasks ((mover-avion ?a1 ?c1 ?c2) (debark ?p1 ?a1 ?c2) (transport-person)))

   (:method Case6 
 	 :precondition (and (at ?p1 - person ?c1 - city) (destino ?p2 - person ?c2 - city) (= ?c1 ?c2) (= ?p1 ?p2))
 	 :tasks ()))

(:task mover-avion
    :parameters (?a1 - aircraft ?c1 - city ?c2 - city)
    (:method fuel-suficiente-para-viaje-rapido
     :precondition (and (hay-fuel-para-viaje-rapido ?a1 ?c1 ?c2) (limite-permitido-rapido ?a1 ?c1 ?c2))
     :tasks((zoom ?a1 ?c1 ?c2)))

    (:method no-fuel-para-viaje-rapido
      :precondition (and (not(hay-fuel-para-viaje-rapido ?a1 ?c1 ?c2)) (not(hay-fuel-para-viaje-lento ?a1 ?c1 ?c2)) (limite-permitido-rapido ?a1 ?c1 ?c2))
      :tasks((refuel ?a1 ?c1)(zoom ?a1 ?c1 ?c2)))

    (:method fuel-suficiente-para-viaje-lento
      :precondition (and (hay-fuel-para-viaje-lento ?a1 ?c1 ?c2) (not(hay-fuel-para-viaje-rapido ?a1 ?c1 ?c2)) (limite-permitido-lento ?a1 ?c1 ?c2))
      :tasks ((fly ?a1 ?c1 ?c2)))

    (:method no-fuel-para-viaje-lento
      :precondition (and (not(hay-fuel-para-viaje-lento ?a1 ?c1 ?c2)) (not(hay-fuel-para-viaje-rapido ?a1 ?c1 ?c2)) (limite-permitido-lento ?a1 ?c1 ?c2))
      :tasks ((refuel ?a1 ?c1) (fly ?a1 ?c1 ?c2)))
)


 
(:import "Primitivas-Zenotravel-ej4.pddl") 

)
