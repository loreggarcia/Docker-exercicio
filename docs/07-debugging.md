# Diagnóstico em ordem
Siga a árvore. Em cada passo, se houver falha, investigue-a antes de avançar:

```text
config válido? ─ não → corrigir YAML/modelo
  ↓ sim
build conclui? ─ não → contexto, COPY, dependências
  ↓ sim
ps -a em execução? ─ não → logs e processo principal
  ↓ sim
logs sem falhas? → processo e porta interna → publicação do host
  ↓
rede e DNS corretos? → endpoint direto e proxy → URI recebida
  ↓
saúde e prontidão → imagem/código atualizado e rebuild
```

| Sintoma | Causa provável | Comando de investigação | Correção |
| --- | --- | --- | --- |
| YAML inválido | indentação/tipo | `docker compose config` | corrigir estrutura |
| Build falha | COPY/contexto/dependência | `docker compose build api` | revisar arquivos e contexto |
| Exited | processo terminou/falhou | `docker compose ps -a`, `docker compose logs api` | corrigir CMD/processo |
| 502 | upstream indisponível ou bind local | `docker compose logs frontend`, `docker compose logs api` | DNS, bind 0.0.0.0, saúde |
| 404 | URI/método incompatível | `docker compose exec frontend nginx -T` | revisar location e barra final |
| Conexão recusada | porta errada/processo ausente | `docker compose port frontend 80` | publicar HOST:80 e verificar processo |
| Porta ocupada | outro processo usa host | `ss -ltn` | escolher porta livre; não matar terceiros |
| api não resolvido | nome/rede diferentes | `docker compose exec frontend nslookup api` | alinhar serviço e rede |
| Código antigo | imagem não reconstruída | `docker compose images` | `docker compose up --build -d` |
| Saúde interna, navegador sem acesso | host/proxy/rota incorretos | `curl -i http://localhost:8080/api/health` | navegador usa frontend, Nginx usa api |
| Primeira chamada falha | início sem prontidão | `docker compose ps`, logs | healthcheck e service_healthy |

Nos exemplos Python, teste escuta interna com `docker compose exec api python -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:5000/health').read())"`. A partir do frontend, `docker compose exec frontend wget -qO- http://api:5000/health` verifica alcance de rede. Um sucesso no loopback não comprova bind em 0.0.0.0.

Confira o modelo com config, publicação com port, rede com `docker network inspect NOME` e configuração efetiva com nginx -T. Use ferramentas presentes na imagem: scratch não tem shell nem wget, e Python slim pode não ter ss. Logs de acesso da API mostram a URI recebida. Uma API que encerra pode desaparecer do DNS interno e fazer o Nginx também encerrar após timeout; confirme o primeiro erro pelos logs da API, em vez de presumir um único sintoma. Se a API for recriada e Nginx mantiver um IP antigo, recrie frontend após a API.

[Pratique os cenários](../exercises/03-debugging-scenarios/README.md) e registre decisões antes de consultar soluções.
