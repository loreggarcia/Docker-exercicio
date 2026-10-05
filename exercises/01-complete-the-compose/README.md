# Completar o Compose
Aplicações, Dockerfiles e Nginx estão prontos. Complete apenas compose.yaml. O arquivo inicial `services: {}` é YAML válido, e esta versão do Compose aceita `config` mesmo sem serviços. `up` ainda não tem serviços para executar; após completar, valide configuração e comportamento.

Critérios: serviços frontend e api; builds ./frontend e ./api; publicação 8081:80 somente frontend; dependência frontend → api; rede padrão; Nginx resolvendo api:5000; saúde, echo válido 200 e inválido 400 pelo frontend. Colete config, ps -a, logs e HTTP e preencha [registro](registro-5c.md) com suas palavras.

```bash
docker compose config
docker compose up --build -d
docker compose ps -a
docker compose logs --tail=50
curl -i http://localhost:8081/api/health
curl -i http://localhost:8081/api/echo -H 'Content-Type: application/json' -d '{"message":"Hello Docker"}'
curl -i http://localhost:8081/api/echo -H 'Content-Type: application/json' -d '{"message":""}'
docker compose down
```
No navegador, envie uma mensagem, depois uma mensagem vazia. Observe carregamento, sucesso, erro e botão disponível após concluir. Espere 200 com o JSON do contrato no sucesso e 400 com `error` no erro.
