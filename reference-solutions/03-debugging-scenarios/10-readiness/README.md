# Diagnóstico 10
Adicione healthcheck à API e depends_on api condition: service_healthy como no exemplo avançado. Repita o teste desde down para observar a espera.

Investigue no diretório do exercício: `docker compose ps; docker compose logs api`. Depois de corrigir, execute config, up --build -d, ps -a e curl de saúde e echo (válido e vazio). Espere saúde 200, echo 200 e erro 400. Compare estado e logs antes e depois; config válido não prova que a aplicação funciona.

O [Compose corrigido](compose.yaml) pode ser executado nesta pasta; publica somente 8090:80. Encerre outro cenário que use essa porta antes.

Mesmo com a API saudável, aguarde Nginx começar a atender HTTP: service_healthy verifica a dependência, não a prontidão do frontend.
