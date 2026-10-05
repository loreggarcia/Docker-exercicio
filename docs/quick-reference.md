# Consulta rápida

| Preciso… | Comando ou arquivo |
| --- | --- |
| Validar modelo | `docker compose config` |
| Construir sem iniciar | `docker compose build` |
| Construir e iniciar | `docker compose up --build -d` |
| Ver parados também | `docker compose ps -a` |
| Ver motivo da falha | `docker compose logs --tail=50 api` |
| Ver porta publicada | `docker compose port frontend 80` |
| Testar DNS | `docker compose exec frontend nslookup api` |
| Testar API na rede | `docker compose exec frontend wget -qO- http://api:5000/health` |
| Inspecionar Nginx | `docker compose exec frontend nginx -T` |
| Encerrar projeto | `docker compose down` |

Dockerfile constrói; Compose executa e conecta; Nginx encaminha HTTP. Navegador usa localhost:8080; proxy usa api:5000. Caminhos relativos devem ser executados na pasta do exemplo. Veja [diagnóstico](07-debugging.md).
