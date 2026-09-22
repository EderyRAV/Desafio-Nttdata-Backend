@deleteUsuariosId
Feature: eliminar usuarios
Background:
  * url baseUrl
  * def schemaRequest = read ("classpath:resources/schema/usuarios/deleteUsuariosId.json")
  * def usuario = call read('postUsuarios.feature@smoke')
  * def id = usuario.id

@smoke
Scenario: verificar que el servicio esté disponible
* def usuario = call read('postUsuarios.feature@smoke')
Given path 'usuarios', usuario.id
When method DELETE
Then status 200
And match response == schemaRequest['200']
    

@happy-path
Scenario: verificar la respuesta del servicio cuando se elimina un usuario existente
Given path 'usuarios', usuario.id
When method DELETE
Then status 200
And match response == schemaRequest['200']
And match response.message == "Registro excluído com sucesso"

@unhappy-path
Scenario: verificar la respuesta cuando se intenta eliminar un id que no existe
Given path 'usuarios', 'idQueNoExisteQA123'
When method DELETE
Then status 200
And match response == schemaRequest['200']
And match response.message == "Nenhum registro excluído"

@fields
Scenario: verificar la respuesta cuando no se envia el id
Given path 'usuarios'
When method DELETE
Then status 405
And match response == schemaRequest['405']
And match response.message == "Não é possível realizar DELETE em /usuarios. Acesse https://serverest.dev para ver as rotas disponíveis e como utilizá-las."

@fields
Scenario Outline: verificar la respuesta cuando el id tiene un formato <tipo>
Given path 'usuarios', '<id>'
When method DELETE
Then status 200
And match response == schemaRequest['200']
And match response.message == "Nenhum registro excluído"
Examples:
|tipo|id|
|numerico|123456|
|con caracteres especiales|abc-123_QA!|
|muy largo|aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa|
