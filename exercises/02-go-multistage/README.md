# Substituir a API por Go
O código em api/ preserva GET /health e POST /echo. Crie api/Dockerfile multi-stage e compose.yaml. Os arquivos iniciais são placeholders intencionais: Compose pode aceitar config sem serviços, mas não executa a aplicação e Dockerfile sem FROM não constrói.

Reutilize `../../examples/02-multistage-web/frontend` como contexto sem modificar o frontend. Crie api com contexto ./api, mantenha esse nome DNS, publique somente frontend em 8082:80. Gere binário Linux estático em builder e copie somente esse binário para runtime mínimo. Rede padrão ou bridge declarada são aceitas.

Critérios: 200 no health e echo válido, 400 com JSON de erro para mensagem vazia, corpo ausente e JSON inválido; API sem publicação; config válido; evidências de estado e logs; frontend preservado. Preencha [registro](registro-5c.md).

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
