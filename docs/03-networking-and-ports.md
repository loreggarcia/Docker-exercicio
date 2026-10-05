# Redes, DNS e portas
O exemplo básico recebe uma rede padrão `<projeto>_default`. No avançado, ambos os serviços participam da rede bridge `echo-net`, cujo nome real também recebe prefixo do projeto. Isso evita colisões entre execuções.

O DNS interno resolve o serviço `api`. Não memorize IPs: eles podem mudar. `localhost` dentro do frontend aponta para o próprio frontend; dentro da API aponta para a API; no navegador aponta para o computador do usuário. O navegador não resolve `api`: ele chama `/api/echo` no frontend e Nginx consulta `api:5000`.

| Declaração | Efeito |
| --- | --- |
| `EXPOSE 5000` | Documenta uma porta na imagem; não publica |
| `expose: ["5000"]` | Documenta a porta do serviço; não publica |
| `ports: ["8080:80"]` | Publica porta 8080 do host para 80 do container |

Containers na mesma rede podem acessar a porta de escuta sem `expose`. A API deve ouvir em `0.0.0.0:5000`; o host acessa apenas frontend. Não publicar API reduz a superfície acessível pelo host, mas não constitui autenticação nem isolamento contra participantes da mesma rede.

Investigue com `docker compose port frontend 80`, `docker compose exec frontend nslookup api` e `docker network ls`. Veja [redes no Compose](https://docs.docker.com/compose/how-tos/networking/).
