@getUsuariosId
Feature: obtener usuarios

  Background:
    * url baseUrl
    * def baseRequest = read ("classpath:resources/request/postUsuarios.json")
    * def schemaRequest = read ("classpath:resources/schema/usuarios/getUsuariosId.json")
    * def usuario = call read('postUsuarios.feature@smoke')
    * def id = usuario.id 
    * def correoAux = java.util.UUID.randomUUID().toString() + '@qa.com.br'

@smoke
Scenario: verificar que el servicio esté disponible
Given path 'usuarios', id
When method GET
Then status 200
And match response == schemaRequest['200']


@happy-path
Scenario: verificar que se obtienen los datos correctos de un usuario existente
Given copy customRequest = baseRequest
* set customRequest.nome = 'Usuario Consulta QA'
* set customRequest.email = correoAux
Given path 'usuarios'
And request customRequest
When method POST
Then status 201
* def idPropio = response._id

Given path 'usuarios', idPropio
When method GET
Then status 200
And match response == schemaRequest['200']
And match response.email == correoAux
And match response.nome == 'Usuario Consulta QA'


@unhappy-path
Scenario: verificar la respuesta cuando se consulta un id con formato valido que no existe
Given path 'usuarios', '1234567890123456'
When method GET
Then status 400
And match response == schemaRequest['400']
And match response.message == "Usuário não encontrado"


@fields
Scenario Outline: verificar la respuesta cuando el id no tiene el formato esperado (<tipo>)
Given path 'usuarios', '<id>'
When method GET
Then status 400
And match response.id == 'id deve ter exatamente 16 caracteres alfanuméricos'
Examples:
|tipo|id|
|muy corto|abc123|
|con caracteres especiales|aQwErTyUiOpZxC-1|
|muy largo|aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa|
