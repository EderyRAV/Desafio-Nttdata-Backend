@putUsuariosId
Feature: modificar usuarios

  Background:
    * url baseUrl
    * def baseRequest = read ("classpath:resources/request/putUsuariosId.json")
    * def schemaRequest = read ("classpath:resources/schema/usuarios/putUsuariosId.json")
    * def usuario = call read('postUsuarios.feature@smoke')
    * def id = usuario.id 
    * def correoAux = java.util.UUID.randomUUID().toString() + '@qa.com.br'
    * def correoOtro = java.util.UUID.randomUUID().toString() + '@qa.com.br'

@smoke
Scenario: verificar que el servicio esté disponible
Given copy customRequest = baseRequest
* set customRequest.email = correoAux
Given path 'usuarios', usuario.id
And request customRequest
When method PUT
Then status 200
And match response == schemaRequest['200']


@happy-path
Scenario: verificar la respuesta cuando se actualiza un usuario existente con datos validos
Given copy customRequest = baseRequest
* set customRequest.nome = 'Usuario Actualizado QA'
* set customRequest.email = correoAux
Given path 'usuarios', usuario.id
And request customRequest
When method PUT
Then status 200
And match response == schemaRequest['200']
And match response.message == "Registro alterado com sucesso"


@happy-path
Scenario: verificar que se crea un usuario nuevo cuando el id enviado tiene formato valido pero no existe
Given copy customRequest = baseRequest
* set customRequest.email = correoAux
Given path 'usuarios', '1234567890123456'
And request customRequest
When method PUT
Then status 201
And match response == schemaRequest['201']
And match response.message == "Cadastro realizado com sucesso"


@unhappy-path
Scenario: verificar el rechazo cuando se actualiza el email a uno ya utilizado por otro usuario
Given copy otroUsuarioRequest = baseRequest
* set otroUsuarioRequest.nome = 'Usuario Existente QA'
* set otroUsuarioRequest.email = correoOtro
Given path 'usuarios'
And request otroUsuarioRequest
When method POST
Then status 201

* def usuario = call read('postUsuarios.feature@smoke')
Given copy customRequest = baseRequest
* set customRequest.email = correoOtro
Given path 'usuarios', usuario.id
And request customRequest
When method PUT
Then status 400
And match response == schemaRequest['400']
And match response.message == "Este email já está sendo usado"


@fields
Scenario Outline: verificar rechazo cuando no se envia el dato <campo>
Given copy customRequest = baseRequest
# mismo caso que en @smoke/@happy-path: correoAux ya trae el dominio, no se concatena de nuevo
* set customRequest.email = correoAux
    * karate.remove ('customRequest','<campo>')
Given path 'usuarios', usuario.id
And request customRequest
When method PUT
Then status 400
And match response.<campo> contains "obrigatório"
Examples:
|campo|
|email|
|password|
|nome|
|administrador|


@fields
Scenario Outline: verificar rechazo cuando envio el dato <campo> vacio
Given copy customRequest = baseRequest
* set customRequest.<campo> = ""
Given path 'usuarios', usuario.id
And request customRequest
When method PUT
Then status 400
And match response.<campo> contains "branco"
Examples:
|campo|
|email|
|password|
|nome|


@data-type
Scenario Outline: verificar el rechazo cuando se envia un <campo> <tipo>
Given copy customRequest = baseRequest
* set customRequest.<campo> = <valor>
Given path 'usuarios', usuario.id
And request customRequest
When method PUT
Then status 400
And match response.<campo> contains "<tipoEsperado>"
Examples:
|campo|valor|tipo|tipoEsperado|
|email|132300|numerico|string|
|nome|67|numerico|string|
|password|false|booleano|string|
|administrador|"hola"|string|true|
