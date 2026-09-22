@getUsuarios
Feature: Listar usuarios

  Background:
    * url baseUrl
    * def usuarioSchema = read ("classpath:resources/schema/common/usuario.json")
    * def schemaRequest = read ("classpath:resources/schema/usuarios/getUsuarios.json")
    * def baseRequest = read ("classpath:resources/request/postUsuarios.json")
    * def correoAux = java.util.UUID.randomUUID().toString() + '@qa.com.br'


@smoke
Scenario: verificar que el servicio esté disponible
Given path 'usuarios'
When method GET
Then status 200
And match response == schemaRequest['200']


@happy-path
Scenario: verificar que el filtro por email retorna únicamente el usuario esperado
Given copy customRequest = baseRequest
* set customRequest.email = correoAux
Given path 'usuarios'
And request customRequest
When method POST
Then status 201

Given path 'usuarios'
And param email = correoAux
When method GET
Then status 200
And match response == schemaRequest['200']
And match response.quantidade == 1
And match response.usuarios[0].email == correoAux


@fields
Scenario: verificar el rechazo cuando se envia un parámetro de filtro no soportado
Given path 'usuarios'
And param paramInventadoQA = 'xyz'
When method GET
Then status 400
And match response.paramInventadoQA == "paramInventadoQA não é permitido"
