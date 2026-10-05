# Cenário 10
Sintoma observado: O frontend inicia antes da API responder; primeiras chamadas podem receber 502.

Objetivo: Observe estado de início, tempo até saúde e significado da dependência.

Execute nesta pasta, um cenário por vez. Use `docker compose config`, `docker compose up --build -d`, `docker compose ps -a`, logs e `curl -i http://localhost:8090/api/health`. 
Registre hipótese, teste e evidência em um registro 5C próprio. O defeito é intencional. A porta do host usada pela configuração pode estar ocupada; não encerre processos de terceiros. Encerre este projeto com `docker compose down`.
