# Diagnóstico 05
Adicione / após api:5000 em proxy_pass. /api/health deve chegar como /health.

Investigue no diretório do exercício: `docker compose logs api`. Depois de corrigir, execute config, up --build -d, ps -a e curl de saúde e echo (válido e vazio). Espere saúde 200, echo 200 e erro 400. Compare estado e logs antes e depois; config válido não prova que a aplicação funciona.

O [Compose corrigido](compose.yaml) pode ser executado nesta pasta; publica somente 8090:80. Encerre outro cenário que use essa porta antes.
