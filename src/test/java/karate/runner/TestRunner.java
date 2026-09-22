package karate.runner;

import com.intuit.karate.junit5.Karate;

/**
 * Runner por defecto: ejecuta todos los features del proyecto,
 * excluyendo cualquier Scenario marcado con @ignore.
 *
 * Ejecutar con: mvn test -Dtest=TestRunner
 */
class TestRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:resources/features").tags("~@ignore").outputCucumberJson(true).outputJunitXml(true);
    }
}
