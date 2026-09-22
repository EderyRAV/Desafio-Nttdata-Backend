@deleteUsuariosId
Feature: eliminar usuarios
Background: 
    * url baseUrl
    * def id = "0uxuPY0cbmQhpEz1"
 * path 'usuarios', id
@smoke
Scenario: verificar que el servicio esté disponible
When method DELETE 
Then status 200