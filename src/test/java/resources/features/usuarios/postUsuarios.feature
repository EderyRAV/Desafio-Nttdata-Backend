@postUsuarios
Feature: registrar usuarios
Background: 
    * url baseUrl
    * path 'usuarios'
* def baseRequest = read ("classpath:resources/request/postUsuarios.json")
* def schemaRequest = read ("classpath:resources/schema/usuarios/postUsuarios.json")
* def correoAux = java.util.UUID.randomUUID().toString()



@smoke
Scenario: verificar que el servicio esté disponible
Given copy customRequest = baseRequest
* set customRequest.email = correoAux + '@qa.com.br'
Given request customRequest
When method POST
Then status 201
And match response == schemaRequest['201']
* def id = response._id


@happy-path
Scenario: verificar la respuesta del servicio cuando tenga un envio correcto
Given copy customRequest = baseRequest
* set customRequest.email = correoAux + '@qa.com.br'
Given request customRequest
When method POST
Then status 201
And match response == schemaRequest['201']
And match response.message == "Cadastro realizado com sucesso"


@unhappy-path
Scenario: verificar la NO duplicación cuando se envia un correo en uso
Given copy customRequest = baseRequest
* set customRequest.email = correoAux + '@qa.com.br'
Given request customRequest
When method POST
    * path 'usuarios'
Given request customRequest
When method POST
Then status 400
And match response == schemaRequest['400']
And match response.message == "Este email já está sendo usado"


@data-type
Scenario Outline: verificar el rechazo cuando se envia un <campo> <tipo>
Given copy customRequest = baseRequest
* set customRequest.<campo> = <valor>
Given request customRequest
When method POST
Then status 400
And match response.<campo> contains "<tipoEsperado>"
Examples: 
|campo|valor|tipo|tipoEsperado|
|email|132300|numerico|string|
|nome|67|numerico|string|
|password|false|booleano|string|
|administrador|"hola"|string|true|


@fields
Scenario Outline: verificar rechazo cuando no envio el dato <campo>
Given copy customRequest = baseRequest
* set customRequest.email = correoAux + '@qa.com.br'
    * karate.remove ('customRequest','<campo>')
Given request customRequest
When method POST
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
Given request customRequest
When method POST
Then status 400
And match response.<campo> contains "branco"
Examples: 
|campo|
|email|
|password|
|nome|