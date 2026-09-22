# Desafio-Nttdata-Backend

Suite de pruebas automatizadas con **Karate DSL** para la API de Usuarios de [ServeRest](https://serverest.dev/).

## Requisitos

- Java 17+
- Maven

## Ejecutar las pruebas

```bash
mvn clean test
```

Para correr solo un tag:

```bash
mvn test -Dkarate.options="--tags @deleteUsuariosId"
```

## Resultados

Reporte HTML en `target/karate-reports/karate-summary.html`.
