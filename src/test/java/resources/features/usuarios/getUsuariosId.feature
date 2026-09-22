@getUsuariosId
Feature: obtener usuarios
Background: 
    * url baseUrl
    * path 'usuarios'
* def schemaRequest = read ("classpath:resources/schema/usuarios/getUsuariosId.json")
* def correoAux = java.util.UUID.randomUUID().toString()
#
* def usuario = call read('postUsuarios.feature@smoke')
* def id = usuario.id


@smoke
Scenario: verificar que el servicio esté disponible
    * path id
When method GET
Then status 200
And match response == schemaRequest['200']

#id = 1111111111111 invalidar
#id es vacio -> 400
#10 por cada CRUD
