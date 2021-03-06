import bandejas.*

class Persona{
	var posicion
	var elementosCercanos = []
	var criterio
	var criterioComida
	var comidaConsumida = []
	
	method elementosCercanos() = elementosCercanos
	
	method comidaConsumida() = comidaConsumida
	
	method tomarPrimerCercano() = elementosCercanos.first()
	
	method pasaTodos(personaQuePide){
		elementosCercanos.forEach({elemento => elemento.esPasado(self,personaQuePide)})
	}
	
	method agregarCriterio(nuevoCriterio){
		criterio = nuevoCriterio
	}
	
	method agregarCriterioComida(nuevoCC){
		criterioComida = nuevoCC
	}
	
	method agregarElementoCercano(nuevoElemento){
		elementosCercanos.add(nuevoElemento)
	}
	
	method sacarElementoCercano(elemento){
		elementosCercanos.remove(elemento)
	}
	
	method posicion() = posicion
	
	method cambiarPosicion(pos){
		posicion = pos
	} 
	
	method puedePasar(nombreElemento) = elementosCercanos.any({elemento => elemento.esElBuscado(nombreElemento)})
	
	method comoActuo(personaQuePide,elemento) = criterio.queLePasa(self,personaQuePide,elemento)
	
	method recibePedidoDe(personaQuePide,elemento){
		const nombreElemento = elemento.nombre()
		
		if(self.puedePasar(nombreElemento)){
			
		self.comoActuo(personaQuePide,elemento)
		
		}else{
			self.error("No tengo eso")
		}
	} 
	
	method lePideA(personaQueDa,elementoPedido){
		if(elementoPedido.nombre() == "cambio"){
			self.comoActuo(personaQueDa,elementoPedido) // si pide cambio no se fija que lo tenga en cercanos
		}else{
		 personaQueDa.recibePedidoDe(self,elementoPedido)
		 
		 }
	}
	
	method quiereComer(comida){
		if(criterioComida.seLoPermite(comida)){
			comidaConsumida.add(comida)
		}
	}
	
	method estaPipon() = comidaConsumida.any({comida => comida.esPesada()})
	
	method laEstaPasandoBien()
}

object osky inherits Persona{
	override method laEstaPasandoBien() = true
}

object moni inherits Persona{
	override method laEstaPasandoBien() = posicion == 1
}

object facu inherits Persona{
	override method laEstaPasandoBien() = comidaConsumida.any({comida => not(comida.esVegetariano())})
}

object vero inherits Persona{
	override method laEstaPasandoBien() = elementosCercanos.size() < 3
}

class Elemento{
	var nombre
	
	method nombre() = nombre
	method esElBuscado(unNombre) = nombre == unNombre
	
	method esPasado(personaQueDa,personaQuePide){
		personaQueDa.sacarElementoCercano(self)
		personaQuePide.agregarElementoCercano(self)
	}
}

class Criterio{ // si esta clase no estubiese, habria entonces una interfaz entre todos los ojetos condicion ya que todos entenderian el msg
				// que le pasa
	
	method queLePasa(personaQueDa,personaQuePide,elementoPedido)

}

object sordo inherits Criterio{
	override method queLePasa(personaQueDa,personaQuePide,elementoPedido){
		const elementoNuevo = personaQueDa.tomarPrimerCercano()
		elementoNuevo.esPasado(personaQueDa,personaQuePide)
	} 
}

object pasaTodo inherits Criterio{
	override method queLePasa(personaQueDa,personaQuePide,elementoPedido) {
		personaQueDa.pasaTodos(personaQuePide)		 
	 }
}

object pideCambio inherits Criterio{

	override method queLePasa(personaQueDa,personaQuePide,elemento){
		const posicion1 = personaQueDa.posicion()
		const posicion2 = personaQuePide.posicion()
		personaQueDa.cambiarPosicion(posicion2)
		personaQuePide.cambiarPosicion(posicion1)
	}
	
}

object pasaElPedido inherits Criterio{
	override method queLePasa(personaQueDa,personaQuePide,elemento){
		elemento.esPasado(personaQueDa,personaQuePide)
	}
}
