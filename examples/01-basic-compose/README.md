# Compose básico
Execute nesta pasta. A rede padrão conecta frontend e api pelo DNS `api`. Somente frontend publica 8080:80. Nginx escuta 80 e encaminha `/api/echo` como `/echo` para api:5000. API escuta em 0.0.0.0; não precisa de `ports` nem `expose` para ser acessada na rede.

`depends_on` simples ordena início, sem garantir prontidão. Aguarde `/api/health` responder antes de testar; consulte logs se não ocorrer. O Dockerfile instala dependências antes do código para aproveitar cache e usa CMD executável.

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

Validação automatizada na raiz: `./scripts/validate-basic.sh`.
