# Cenário 06
Sintoma observado: Aplicação funciona, mas existe acesso direto adicional pelo host.

Objetivo: Inspecione quais serviços publicam portas e quais acessos o contrato exige.

Execute nesta pasta, um cenário por vez. Use `docker compose config`, `docker compose up --build -d`, `docker compose ps -a`, logs e `curl -i http://localhost:8090/api/health`. 
Registre hipótese, teste e evidência em um registro 5C próprio. O defeito é intencional. A porta do host usada pela configuração pode estar ocupada; não encerre processos de terceiros. Encerre este projeto com `docker compose down`.
