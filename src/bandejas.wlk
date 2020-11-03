class Bandeja{
	var comidaQueTiene
	
	method pasarBandeja(persona) = persona.quiereComer(comidaQueTiene)
}


class Comida{
	var calorias
	var tipo = "" //carne o verdura 
	var nombre
	
	method esDietetico() = calorias < 500
	method esVegetariano() = tipo == "verdura"
	method nombre() = nombre
	
	method esElBuscado(comida) = nombre == comida.nombre()
	
	method esPesada() = not(self.esDietetico())
}

const pechitoDeCerdo = new Comida(calorias =270,tipo = "carne",nombre = "pechito de cerdo")

class Condicion{ // si esta clase no estuviese,entonces seria una interfaz de las condicionesComida
	
	method seLoPermite(comida)
}

object vegetariano inherits Condicion{
	override method seLoPermite(comida) = comida.esVegetariano()
}

object dietetico inherits Condicion{
	var recomendaciones = [] //comidas recomendadas
	override method seLoPermite(comida) = comida.esDietetico() || recomendaciones.any({recomendacion => recomendacion.esElBuscado(comida)})
}



object alternado inherits Condicion{
	override method seLoPermite(comida) = true
}

class CombinacionCondiciones inherits Condicion{ //lo hago clase para que haya varios tipos distinos de condiciones en el listado
	var listadoCondiciones = []
	
	override method seLoPermite(comida) = listadoCondiciones.all({condicion => condicion.seLoPermite(comida)})
		
}