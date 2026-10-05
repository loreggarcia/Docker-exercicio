# Cenário 09
Sintoma observado: Após editar uma dependência e executar restart, a versão instalada continua antiga.

Objetivo: Compare arquivo do host, imagem e dependência carregada.

Execute nesta pasta, um cenário por vez. Use `docker compose config`, `docker compose up --build -d`, `docker compose ps -a`, logs e `curl -i http://localhost:8090/api/health`. 
Após up --build, altere gunicorn==23.0.0 para gunicorn==22.0.0 em api/requirements.txt e execute `docker compose restart api`. Compare a versão instalada com o arquivo.

Registre hipótese, teste e evidência em um registro 5C próprio. O defeito é intencional. A porta do host usada pela configuração pode estar ocupada; não encerre processos de terceiros. Encerre este projeto com `docker compose down`.
