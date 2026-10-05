# Web multi-stage
Execute nesta pasta e encerre antes o básico: ambos usam 8080.

Node gera dist/ usando npm ci e o lockfile. Somente dist/ atravessa os estágios; Nginx recebe também sua configuração local. O builder Python prepara /opt/venv; runtime recebe venv e app.py e executa como usuário 10001. Mesmo Python e família de imagem garantem compatibilidade do venv.

Builders não são serviços. Compose conecta as imagens resultantes à bridge echo-net (com prefixo do projeto). `expose` documenta 5000 sem restringir acesso. Healthcheck consulta a API internamente e `service_healthy` condiciona o início do frontend; não é recuperação automática de falhas futuras.

```bash
docker compose config
docker compose up --build -d
docker compose ps -a
docker compose logs --tail=50
curl -i http://localhost:8080/api/health
curl -i http://localhost:8080/api/echo -H 'Content-Type: application/json' -d '{"message":"Hello Docker"}'
curl -i http://localhost:8080/api/echo -H 'Content-Type: application/json' -d '{"message":""}'
docker compose down
```
No navegador, envie uma mensagem, depois uma mensagem vazia. Observe carregamento, sucesso, erro e botão disponível após concluir. Espere 200 com o JSON do contrato no sucesso e 400 com `error` no erro.

Na raiz: `./scripts/validate-multistage.sh`. Para estudar separadamente: `docker build --target builder -t echo-node-builder:local frontend`.
