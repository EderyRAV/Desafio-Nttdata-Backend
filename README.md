# Karate Cucumber Framework (base)

Framework base para pruebas de API con **Karate**. Karate usa el mismo lenguaje
Gherkin de Cucumber para escribir los `.feature` (Given/When/Then), por eso a
menudo se le llama "Karate con Cucumber". Una nota importante para que no te
sorprenda si ves tutoriales antiguos: desde Karate 1.4 el runner clásico de
JUnit4 + `@CucumberOptions` (basado en cucumber-jvm) está descontinuado. El
runner soportado hoy es el de **JUnit 5**, que es el que usa este proyecto.
Aun así, puedes generar reportes en **formato Cucumber JSON** (ver
`RegressionTestRunner`) para integrarlo con herramientas tipo Jenkins
Cucumber Reports.

## Estructura del proyecto

```
karate-cucumber-framework/
├── pom.xml
├── src/test/java/
│   ├── runners/
│   │   ├── TestRunner.java            -> corre todo, excepto @ignore
│   │   ├── SmokeTestRunner.java       -> corre solo @smoke
│   │   └── RegressionTestRunner.java  -> corre @regression en paralelo + reporte Cucumber JSON
│   └── features/
│       ├── common/auth.feature        -> feature reutilizable de login (call read)
│       ├── users/get-users.feature    -> ejemplos de GET, match, Scenario Outline
│       └── posts/
│           ├── manage-posts.feature   -> ejemplos de POST/PUT/DELETE, @ignore
│           └── post-schema.js         -> esquema reutilizable con "read()"
└── src/test/resources/
    ├── karate-config.js               -> configuración por entorno (dev/qa/prod)
    └── logback-test.xml               -> logging de las pruebas
```

Los `.feature` viven junto a los runners en `src/test/java` (convención
habitual de Karate); el `pom.xml` ya está configurado para incluirlos como
recursos de test.

Los ejemplos apuntan a la API pública gratuita
[jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com) para que
el proyecto corra "out of the box" sin necesitar credenciales. Reemplaza
`baseUrl` en `karate-config.js` y los endpoints en los `.feature` por los de
tu propia API.

## Requisitos

- Java 17+
- Maven 3.8+

## Cómo ejecutar

```bash
# Todo el suite (excepto @ignore)
mvn test -Dtest=TestRunner

# Solo smoke tests
mvn test -Dtest=SmokeTestRunner

# Regresión en paralelo + reporte Cucumber JSON
mvn test -Dtest=RegressionTestRunner

# Cambiar de entorno (dev/qa/prod, definido en karate-config.js)
mvn test -Dtest=TestRunner -Dkarate.env=qa
```

## Tags disponibles

- `@smoke` – escenarios críticos, rápidos de ejecutar.
- `@regression` – suite completa de regresión.
- `@ignore` – excluye el escenario de las ejecuciones normales.

Puedes combinar tags al llamar a `Runner`/`Karate.run(...).tags(...)`:

- `tags("~@ignore")` → excluye lo marcado con `@ignore`
- `tags("@smoke", "@regression")` → AND (debe tener ambas tags)
- `tags("@smoke,@regression")` → OR (debe tener alguna de las dos)

## Reportes

- HTML nativo de Karate: `target/karate-reports/karate-summary.html`
- JSON formato Cucumber (si usas `outputCucumberJson(true)`): `target/karate-reports/*.json`
- JUnit XML (si usas `outputJunitXml(true)`): `target/karate-reports/*.xml`

## Buenas prácticas incluidas en este base

- **Background reutilizable** para `url` y autenticación.
- **`call read(...)`** para reutilizar un feature de login desde otros features.
- **Validación de esquema** con archivos `.js` reutilizables (`match response == schema`).
- **Scenario Outline** con `Examples` para probar varios casos con la misma lógica.
- **Separación por tags** para correr subconjuntos de pruebas (smoke vs regresión).
- **Configuración por entorno** centralizada en `karate-config.js` usando `karate.env`.

## Siguientes pasos sugeridos

- Agregar autenticación real (OAuth2, Basic, API Key) en `common/auth.feature`.
- Agregar un `Dockerfile`/stage de CI (GitHub Actions, Jenkins, GitLab CI) que
  corra `mvn test -Dtest=RegressionTestRunner` y publique `target/karate-reports`.
- Si necesitas la última versión mayor de Karate (2.x, con cambios de motor
  respecto a la línea 1.x), revisa la guía de migración oficial antes de
  actualizar el `karate.version` del `pom.xml`.
