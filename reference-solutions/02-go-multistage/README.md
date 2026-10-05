# Solução de referência

Frontend React reutilizado sem mudança; API Go compilada estaticamente e executada em scratch como UID 10001. Apenas frontend publica 8082:80. A API nesta solução é uma cópia neutra do código fornecido, para tornar o contexto de build completo.

Execute nesta pasta após tentar o exercício e comparar suas decisões.

```bash
docker compose config
docker compose up --build -d
docker compose ps -a
docker compose logs --tail=50
curl -i http://localhost:8082/api/health
curl -i http://localhost:8082/api/echo -H 'Content-Type: application/json' -d '{"message":"Hello Docker"}'
curl -i http://localhost:8082/api/echo -H 'Content-Type: application/json' -d '{"message":""}'
docker compose down
```
No navegador, envie uma mensagem, depois uma mensagem vazia. Observe carregamento, sucesso, erro e botão disponível após concluir. Espere 200 com o JSON do contrato no sucesso e 400 com `error` no erro.
