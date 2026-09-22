function fn() {
  var env = karate.env; // se define con -Dkarate.env=qa (o dev/prod)
  karate.log('karate.env ->', env);

  if (!env) {
    env = 'dev';
  }

  var config = {
    env: env,
    baseUrl: 'https://serverest.dev'
  };

  if (env == 'dev') {
    config.baseUrl = 'https://serverest.dev';
  } else if (env == 'qa') {
    config.baseUrl = 'https://serverest.dev';
  } else if (env == 'prod') {
    config.baseUrl = 'https://serverest.dev';
  }

  // Timeouts globales para todas las llamadas HTTP
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 10000);

  // Ejemplo de headers globales si tu API los necesita en todas las llamadas:
  // karate.configure('headers', { 'X-Client-Id': 'karate-framework' });

  return config;
}
