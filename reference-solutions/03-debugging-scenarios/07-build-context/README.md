# Diagnóstico 07
Use ../../../examples/01-basic-compose/api como contexto. config não verifica conteúdo do build.

Investigue no diretório do exercício: `docker compose build api`. Depois de corrigir, execute config, up --build -d, ps -a e curl de saúde e echo (válido e vazio). Espere saúde 200, echo 200 e erro 400. Compare estado e logs antes e depois; config válido não prova que a aplicação funciona.

O [Compose corrigido](compose.yaml) pode ser executado nesta pasta; publica somente 8090:80. Encerre outro cenário que use essa porta antes.
