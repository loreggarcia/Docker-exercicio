# Validação e evidência
Valide configuração, estado e comportamento separadamente. `config` confirma o modelo Compose, mas não executa build nem testa DNS ou Nginx.

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
Espere 200 e JSON do contrato nas duas primeiras requisições; 400 e JSON com `error` na última. Teste também corpo ausente, JSON quebrado, array, null e tipos incorretos. Preserve a mensagem original quando válida.

Scripts na raiz: `./scripts/validate-basic.sh` e `./scripts/validate-multistage.sh`. Eles aguardam até 60 segundos, verificam corpos e status, exibem estado e encerram seu projeto isolado. Falhas coletam logs. Não mate processos em portas ocupadas. No navegador, observe envio, sucesso, erro e possibilidade de reenviar.

Prontidão: iniciado não significa pronto. `depends_on` simples ordena início. Healthcheck observa saúde; `service_healthy` espera essa condição na inicialização. Essa condição verifica a dependência API; o próprio frontend ainda precisa iniciar seu processo e escutar a porta, por isso os testes aguardam HTTP. Isso não garante disponibilidade eterna nem reinicia automaticamente dependentes quando a saúde cai. Veja [ordem no Compose](https://docs.docker.com/compose/how-tos/startup-order/).

Registre comando, data, saída e limitação. Não transforme testes locais em alegações de execução Docker. O [relatório desta construção](validation-report.md) distingue esses casos.
